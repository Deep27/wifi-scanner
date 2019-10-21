import 'package:flutter/material.dart';
import 'package:wifi_scanner/model/spot_data.dart';
import 'package:wifi_scanner/widget/spot_item/spot_ssid.dart';

class SpotListElement extends StatelessWidget {
  final SpotData _spotData;

  SpotListElement(this._spotData);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SpotSsid(_spotData.ssid),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('Level: ${_spotData.level}'),
                Text('BSSID: ${_spotData.bssid}'),
                Text('frequency: ${_spotData.frequency}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
