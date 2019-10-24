import 'package:flutter/foundation.dart';

class UserRepository {
  Future<String> auth({@required String login, @required String password}) async {
    await Future.delayed(Duration(seconds: 1, milliseconds: 500));
    return 'token';
  }

  Future<void> deleteToken() async {
    await Future.delayed(Duration(seconds: 1, milliseconds: 500));
    return;
  }

  Future<void> persistToken(String token) async { 
    await Future.delayed(Duration(seconds: 1, milliseconds: 500));
    return;
  }

  Future<bool> hasToken() async {
    await Future.delayed(Duration(seconds: 1, milliseconds: 500));
    return false;
  }
}
