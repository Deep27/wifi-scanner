import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AppStarted extends AuthEvent {
  @override
  String toString() => 'AppStarted';

  @override
  List<Object> get props => [];
}

class LoggedIn extends AuthEvent {
  final String token;
  LoggedIn({@required this.token});

  @override
  String toString() => 'LoggedIn { token: "$token" }';

  @override
  List<Object> get props => [];
}

class LoggedOut extends AuthEvent {
  @override
  String toString() => 'LoggedOut';

  @override
  List<Object> get props => [];
}
