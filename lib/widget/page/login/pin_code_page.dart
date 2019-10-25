import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:wifi_scanner/route/router.dart';
import 'package:wifi_scanner/widget/page/charts/main_chars.dart';
import 'package:wifi_scanner/widget/page/login/login_faq.dart';


class PinCodePage extends StatefulWidget {
  PinCodePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PasscodeScreen(
        title: 'Введите пароль',
        titleColor: Colors.grey,
        circleUIConfig: CircleUIConfig(
            borderColor: Colors.grey, fillColor: Colors.grey, circleSize: 30),
        keyboardUIConfig: KeyboardUIConfig(
            digitBorderWidth: 1,
            primaryColor: Colors.green,
            deleteButtonTextStyle: TextStyle(color: Colors.grey, fontSize: 15),
            digitTextStyle: TextStyle(fontSize: 30, color: Colors.green)),
        passwordEnteredCallback: _onPasscodeEntered,
        cancelLocalizedText: 'Выход',
        deleteLocalizedText: 'Удалить',
        shouldTriggerVerification: _verificationNotifier.stream,
        backgroundColor: Colors.white,
        cancelCallback: _onPasscodeCancelled,
      ),
    );
  }


  _showLockScreen(BuildContext context,
      {bool opaque,
      CircleUIConfig circleUIConfig,
      KeyboardUIConfig keyboardUIConfig}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
            title: 'Enter App Passcode',
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            cancelLocalizedText: 'Cancel',
            deleteLocalizedText: 'Delete',
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: _onPasscodeCancelled,
          ),
        ));
  }


  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = '111111' == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
        this.isAuthenticated = isValid;
      });
    }
    //Navigator.of(context).pushReplacement(Router.createRoute(SpotsPage()));
    Navigator.of(context).pushReplacement(Router.createRoute(MyHomePage(title: 'Общая информация')));
  }

  _onPasscodeCancelled() {
    Navigator.of(context).pushReplacement(Router.createRoute(LoginFaq()));
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

}
