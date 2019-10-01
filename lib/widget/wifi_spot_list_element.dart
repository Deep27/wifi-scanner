import 'package:flutter/material.dart';
import 'package:wifi/wifi.dart';

class WifiSpotListElement extends StatelessWidget {
  final String _name;
  final int _level;
  final String _ip;
  final _result;
  final List<WifiResult> _results;

  WifiSpotListElement(
      this._name, this._level, this._ip, this._result, this._results);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('$_name Level: $_level, IP: $_ip'),
    );
  }
}
