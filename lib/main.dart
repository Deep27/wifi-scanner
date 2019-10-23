import 'package:flutter/material.dart';
import 'package:wifi_scanner/widget/page/auth/auth_page.dart';

void main() => runApp(IntermeterApp());

class IntermeterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Sberbank Intermeter',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: AuthPage());
}
