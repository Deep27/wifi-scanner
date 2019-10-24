import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:wifi_scanner/bloc/auth/auth_event.dart';
import 'package:wifi_scanner/bloc/auth/auth_state.dart';
import 'package:wifi_scanner/model/user_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc({@required this.userRepository}) : assert(userRepository != null);

  @override
  AuthState get initialState => AuthUninitialized();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) {
      yield AuthInProgress();
      Future.delayed(Duration(seconds: 1, milliseconds: 500));
      final hasToken = await userRepository.hasToken();
      if (hasToken) {
        yield AuthAuthenticated();
      } else {
        yield AuthUnauthenticated();
      } 
    }
    if (event is LoggedIn) {
        await userRepository.persistToken(event.token);
        yield AuthAuthenticated();
    }
    if (event is LoggedOut) {
        await userRepository.deleteToken();
        yield AuthUnauthenticated();
    }
  }
}
