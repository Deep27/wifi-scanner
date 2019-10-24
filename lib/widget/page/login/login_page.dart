import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:wifi_scanner/bloc/auth/auth_bloc.dart';
import 'package:wifi_scanner/bloc/login/login_bloc.dart';
import 'package:wifi_scanner/bloc/login/login_event.dart';
import 'package:wifi_scanner/bloc/login/login_state.dart';
import 'package:wifi_scanner/model/device_info.dart';
import 'package:wifi_scanner/model/profile.dart';
import 'package:wifi_scanner/model/user.dart';
import 'package:wifi_scanner/model/user_repository.dart';
import 'package:wifi_scanner/route/router.dart';
import 'package:wifi_scanner/widget/page/spots/spots_page.dart';

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

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _gospController = TextEditingController();
  final _branchController = TextEditingController();

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(_gospFocus),
                          controller: _loginController,
                          decoration: InputDecoration(
                            hintText: 'Логин',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 5),
                        child: TextField(
                          focusNode: _gospFocus,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(_branchFocus),
                          controller: _gospController,
                          decoration: InputDecoration(
                            hintText: 'ГОСБ',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 5),
                        child: TextField(
                          focusNode: _branchFocus,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_passwordFocus),
                          controller: _branchController,
                          decoration: InputDecoration(
                            hintText: 'ВСП',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 5),
                        child: TextField(
                          focusNode: _passwordFocus,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: _auth,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Пароль',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: FlatButton(
                            child: Text('Авторизация'),
                            onPressed: _auth,
                            color: Theme.of(context).buttonColor,
                          )),
                    ],
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
        User.columnDeviceSerialId: deviceInfo.androidDeviceInfo.androidId
      });
      _postRegister(user);
    }
  }

  _postRegister(User user) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.hostHeader: 'wifi-analyzer.4qube.ru'
    };
    _LOG.i(user.toMap());
    Response response =
        await post('http://wifi-analyzer.4qube.ru/api/register', headers: headers, body: json.encode(user.toMap()));
    int statusCode = response.statusCode;
    if (statusCode == 200) { 
      _LOG.i(response.body);
      Profile profile = Profile.fromMap(json.decode(response.body));
      _LOG.i(profile.toString());
      Navigator.of(context).pushReplacement(Router.createRoute(SpotsPage()));
    } else { 
      _loginBloc.add(LoginError('Status code: $statusCode'));
    }
  }
}
