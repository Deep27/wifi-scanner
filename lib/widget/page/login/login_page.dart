import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_scanner/bloc/auth/auth_bloc.dart';
import 'package:wifi_scanner/bloc/login/login_bloc.dart';
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
  final _focus = FocusNode();

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

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
              if (state is LoginFailure) {
                _onWidgetDidBuild(
                    () => Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('${state.error}'),
                          backgroundColor: Colors.red,
                        )));
              }
              if (state is LoginInitial) {
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
                              FocusScope.of(context).requestFocus(_focus),
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
                          focusNode: _focus,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: _auth,
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

  _auth() {
    Navigator.of(context).pushReplacement(Router.createRoute(SpotsPage()));
    // _loginController.text;
    // _passwordController.text;
    // _LOG.i("Handling button onclick.");
    // final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    // weatherBloc.add(GetWeather(cityName));
  }
}
