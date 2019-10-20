import 'package:flutter/material.dart';
import 'package:wifi_scanner/widget/spots_page.dart';

void main() => runApp(WifiScannerApp());

class WifiScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wifi Scanner',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: SpotsPage(),
    );
  }
}
