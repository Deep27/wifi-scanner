import 'package:flutter/material.dart';
import 'package:wifi_scanner/model/scan_result.dart';
import 'package:wifi_scanner/widget/page/spots/spot_item/spot_ssid.dart';

class SpotListItem extends StatelessWidget {
  final ScanResult _scanResult;

  SpotListItem(this._scanResult);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SpotSsid(_scanResult.ssid),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('Level: ${_scanResult.level}'),
                Text('BSSID: ${_scanResult.bssid}'),
                Text('frequency: ${_scanResult.frequency}'),
                Text('channels: ${_scanResult.channels}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
