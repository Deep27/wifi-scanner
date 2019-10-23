import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:wifi_scanner/bloc/auth/auth_event.dart';
import 'package:wifi_scanner/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
