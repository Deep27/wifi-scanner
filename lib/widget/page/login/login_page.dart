import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_scanner/bloc/auth/auth_bloc.dart';
import 'package:wifi_scanner/bloc/login/login_bloc.dart';
import 'package:wifi_scanner/bloc/login/login_event.dart';
import 'package:wifi_scanner/bloc/login/login_state.dart';
import 'package:wifi_scanner/model/user_repository.dart';
import 'package:wifi_scanner/route/router.dart';
import 'package:wifi_scanner/widget/page/spots/spots_page.dart';

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
                            hintText: 'Login',
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
                            hintText: 'GOSP',
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
                            hintText: 'Branch',
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
                            hintText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: FlatButton(
                            child: Text('Login'),
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
    if (1 == 0) { // @TODO some checks
      _loginBloc.add(LoginError('1 == 1'));
    } else {
      Navigator.of(context).pushReplacement(Router.createRoute(SpotsPage()));
    }
    // _loginController.text;
    // _passwordController.text;
    // _LOG.i("Handling button onclick.");
    // final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    // weatherBloc.add(GetWeather(cityName));
  }
}
