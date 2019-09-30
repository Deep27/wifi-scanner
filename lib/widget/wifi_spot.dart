import 'package:flutter/material.dart';

class WifiSpot extends StatelessWidget {

  final String _name;

  WifiSpot(this._name);

  @override
  Widget build(BuildContext context) {
    return Text(_name);
  }
}
