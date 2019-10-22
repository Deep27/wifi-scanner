import 'package:flutter/material.dart';

class DeviceInfoWidget extends StatelessWidget {
  final String _deviceModel;
  final String _platformVersion;

  DeviceInfoWidget(this._deviceModel, this._platformVersion);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                'Device Info',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Device model: $_deviceModel'),
                Text('Platform version: $_platformVersion')
              ],
            )
          ],
        ),
      ),
    );
  }
}
