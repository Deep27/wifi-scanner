import 'package:flutter/material.dart';

class WifiSpotListElement extends StatelessWidget {

  final String _name;

  WifiSpotListElement(this._name);

  @override
  Widget build(BuildContext context) {
    return Text(_name);
  }
}
