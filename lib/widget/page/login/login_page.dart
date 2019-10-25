import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_scanner/bloc/auth/auth_bloc.dart';
import 'package:wifi_scanner/bloc/login/login_bloc.dart';
import 'package:wifi_scanner/bloc/login/login_event.dart';
import 'package:wifi_scanner/bloc/login/login_state.dart';
import 'package:wifi_scanner/model/device_info.dart';
import 'package:wifi_scanner/model/profile.dart';
import 'package:wifi_scanner/model/user.dart';
import 'package:wifi_scanner/model/user_repository.dart';
import 'package:wifi_scanner/route/router.dart';
import 'package:wifi_scanner/utils/http_utils.dart';
import 'package:wifi_scanner/widget/page/login/pin_code_page.dart';

final _LOG = Logger();

class LoginPage extends StatefulWidget {
  final UserRepository userRepository;

  LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _gospFocus = FocusNode();
  final _branchFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final _loginController = TextEditingController(text: 'A name');
  final _passwordController = TextEditingController(text: 'A password');
  final _gospController = TextEditingController(text: '9038');
  final _branchController = TextEditingController(text: '01259');
  bool _autoValidate = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginBloc _loginBloc;
  AuthBloc _authBloc;

  UserRepository get _userRepo => widget.userRepository;

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _loginBloc = LoginBloc(userRepository: _userRepo, authBloc: _authBloc);
    super.initState();
  }

  @override
  void dispose() {
    _authBloc.close();
    _loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocProvider<LoginBloc>(
          builder: (context) => _loginBloc,
          child: BlocBuilder<LoginBloc, LoginState>(
            bloc: _loginBloc,
            builder: (BuildContext context, LoginState state) {
              _LOG.i("Current state $state");
              if (state is LoginLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is LoginInitial || state is LoginFailure) {
                if (state is LoginFailure) {
                  _onWidgetDidBuild(
                      () => Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('${state.error}'),
                            backgroundColor: Colors.red,
                          )));
                }
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child: Form(
                    autovalidate: _autoValidate,
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 0),
                          child: TextFormField(
                            validator: (String arg) {
                              if(arg.length < 4)
                                return 'Поле не может быть пустым или менее трех символов';
                              else
                                return null;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Учетная запись Sigma',
                              labelText: 'Пользователь',
                            ),
                            onSaved: (_) =>
                                FocusScope.of(context).requestFocus(_gospFocus),
                            controller: _loginController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 1),
                          child: TextFormField(
                            focusNode: _gospFocus,
                            validator: (String arg) {
                              if(arg.isEmpty)
                                return 'Поле не может быть пустым';
                              else
                                return null;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Головное отделение Сбербанка',
                              labelText: 'ГОСБ',
//                              errorText: _validate ? string : null,
                            ),
                            onSaved: (_) => FocusScope.of(context)
                                .requestFocus(_branchFocus),
                            controller: _gospController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 1),
                          child: TextFormField(
                            focusNode: _branchFocus,
                            validator: (String arg) {
                              if(arg.isEmpty)
                                return 'Поле не может быть пустым';
                              else
                                return null;
                            },
                            textInputAction: TextInputAction.next,
                            onSaved: (_) => FocusScope.of(context)
                                .requestFocus(_passwordFocus),
                            controller: _branchController,
                            decoration: InputDecoration(
                              hintText: 'ВСП',
                              labelText: 'Внутреннее структурное подразделение',
                              //errorText: _validate ? string : null,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          child: TextFormField(
                            validator: (String arg) {
                              if(arg.isEmpty || arg.length <= 4)
                                return 'Поле не может быть пустым или менее четырех символов';
                              else
                                return null;
                            },
                            focusNode: _passwordFocus,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: _auth,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintText: 'Пароль',
                              // errorText: _validate ? string : null,
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: FlatButton(
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: Text('Далее'),
                              onPressed: _validateInputs,
                            )),
                      ],
                    ),
                  ),
                );
              } else {
                return null;
              }
            },
            // builder: (BuildContext context, LoginState state) => Container(
          ),
        ),
      );

  _onWidgetDidBuild(Function callback) =>
      WidgetsBinding.instance.addPostFrameCallback((_) => callback());

  _auth() async {
    _loginBloc.add(LoginInProgress());
    if (_loginController.text == 'error') {
      _loginBloc.add(LoginError('No user with name "error"'));
    } else {
      DeviceInfo deviceInfo = await DeviceInfo.instance;
      User user = User.fromMap({
        User.columnId: null,
        User.columnLogin: _loginController.text,
        User.columnGosb: _gospController.text,
        User.columnBranch: _branchController.text,
        User.columnDeviceSerialId: (Platform.isAndroid)
            ? deviceInfo.androidDeviceInfo.androidId
            : deviceInfo.iosDeviceInfo.identifierForVendor
      });
      _postRegister(user);
    }
  }

  String validateName(String value) {
    if (value.length < 0)
      return 'Поле не может быть пустым';
    else
      return null;
  }

  String validateGosb(String value) {
    if (value.length < 0) //&& value.contains(new RegExp("\d{1,4}"))
      return 'Поле не может быть пустым.';
    else
      return null;
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      _auth();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _postRegister(User user) async {
    _LOG.i(user.toMap());
    Response response = await HttpUtils.registerUser(user);
    _LOG.i(response.body);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      Profile profile = Profile.fromMap(json.decode(response.body));
      _LOG.i(profile.toString());
      final prefs = await SharedPreferences.getInstance();
      final deviceInfo = await DeviceInfo.instance; 
      _LOG.i("platform version: ${deviceInfo.androidDeviceInfo.version}");
      prefs.setString('deviceInfoSerialId', Platform.isAndroid ? deviceInfo.androidDeviceInfo.androidId : deviceInfo.iosDeviceInfo.identifierForVendor);
      prefs.setString('platform', Platform.isAndroid ? 'Android' : 'iOS');
      prefs.setString('platformVersion', deviceInfo.platformVersion);
      prefs.setString('deviceModel', Platform.isAndroid ? deviceInfo.androidDeviceInfo.device : deviceInfo.iosDeviceInfo.model);
      prefs.setString('profile', json.encode(profile.toMap()));
      prefs.setString('user', json.encode(user.toMap()));
      Navigator.of(context).pushReplacement(Router.createRoute(PinCodePage()));
    } else {
      _LOG.e('Error (code $statusCode): ${response.body}');
      _loginBloc.add(LoginError('Error (code $statusCode): ${response.body}'));
    }
  }
}
