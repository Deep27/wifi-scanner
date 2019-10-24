import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _logoText('SBERBANK', context),
            _logoText('INTERMETER', context),
          ],
        ),
      ),
    );
  }

  _logoText(String text, BuildContext context) => Text(
        text,
        style: TextStyle(
          fontSize: 40,
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.bold,
        ),
      );
}
