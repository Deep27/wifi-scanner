import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthUninitialized extends AuthState { 
  @override
  List<Object> get props => [];
}

class AuthAuthenticated extends AuthState { 
  @override
  List<Object> get props => [];
}
class AuthUnauthenticated extends AuthState { 
  @override
  List<Object> get props => [];
}
class AuthInProgress extends AuthState { 
  @override
  List<Object> get props => [];
}
