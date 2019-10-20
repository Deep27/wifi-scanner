import 'package:flutter/material.dart';
import 'package:wifi_scanner/model/spot_data.dart';

class SpotListElement extends StatelessWidget {
  final SpotData _spotData;

  SpotListElement(this._spotData);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Text(
        '${_spotData.ssid} Level: ${_spotData.level}',
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
