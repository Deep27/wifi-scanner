import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class Login extends LoginEvent {
  final String login;
  final String gosb;
  final String branch;
  final String password;

  Login(
      {@required this.login,
      @required this.gosb,
      @required this.branch,
      @required this.password});

  @override
  String toString() =>
      'Login process started { login: "$login", password: "$password" }';

  @override
  List<Object> get props => [];
}

class LoginError extends LoginEvent {
  final String errorMessage;

  LoginError(this.errorMessage);

  @override
  String toString() =>
      'Login failure { $errorMessage }';

  @override
  List<Object> get props => [];
}

class LoginInProgress extends LoginEvent { 
  @override
  List<Object> get props => [];
}
