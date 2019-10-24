import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class Login extends LoginEvent {

  final String login;
  final String password;

  Login({@required this.login, @required this.password});

  @override
  String toString() => 'Login process started { login: "$login", password: "$password" }';

  @override
  List<Object> get props => [];
}
