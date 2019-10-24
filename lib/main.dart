import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:wifi_scanner/bloc/auth/auth_bloc.dart';
import 'package:wifi_scanner/bloc/auth/auth_event.dart';
import 'package:wifi_scanner/bloc/auth/auth_state.dart';
import 'package:wifi_scanner/model/user_repository.dart';
import 'package:wifi_scanner/widget/page/login/login_page.dart';
import 'package:wifi_scanner/widget/page/login/pin_code_page.dart';
import 'package:wifi_scanner/widget/page/splash_page.dart';
import 'package:wifi_scanner/widget/page/spots/spots_page.dart';

final _LOG = Logger();

void main() => runApp(IntermeterApp(userRepository: UserRepository()));

class IntermeterApp extends StatefulWidget {
  final UserRepository userRepository;

  IntermeterApp({Key key, @required this.userRepository}) : super(key: key);

  @override
  _IntermeterAppState createState() => _IntermeterAppState();
}

class _IntermeterAppState extends State<IntermeterApp> {
  AuthBloc _authBloc;
  UserRepository get userRepository => widget.userRepository;

  @override
  void initState() {
    _authBloc = AuthBloc(userRepository: userRepository);
    _authBloc.add(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Sberbank Intermeter',
    theme: ThemeData(primarySwatch: Colors.lightGreen),
    home: BlocProvider<AuthBloc>(
      builder: (context) => _authBloc,
      child: BlocBuilder<AuthBloc, AuthState>(
        bloc: _authBloc,
        builder: (BuildContext context, AuthState state) {
          _LOG.i('Started app. State: $state');
          if (state is AuthUninitialized || state is AuthInProgress) {
            return SplashPage();
          }
          if (state is AuthAuthenticated) {
            return SpotsPage();
          }
          if (state is AuthUnauthenticated) {
            return LoginPage(userRepository: userRepository);
          } else {
            return null;
          }
        },
      ),
    ),
  );
}