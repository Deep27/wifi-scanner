import 'package:flutter/material.dart';

import './widget/home_page.dart';

void main() => runApp(WifiScannerApp());

class WifiScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wifi Scanner',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: HomePage(),
    );
  }
}
