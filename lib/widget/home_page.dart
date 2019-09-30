import 'package:flutter/material.dart';
import 'package:wifi_scanner/widget/wifi_spot.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wi-Fi Scanner'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            WifiSpot('A Wi-Fi Scanner Field'),
          ],
        ),
      ),
    );
  }
}
