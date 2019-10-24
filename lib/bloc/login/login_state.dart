import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState { 
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState { 
  @override
  List<Object> get props => [];
}

class LoginFailure extends LoginState { 

  final String error;

  const LoginFailure({@required this.error});

  @override
  toString() => 'LoginFailure { error: "$error" }';

  @override
  List<Object> get props => [];
}
