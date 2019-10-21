import 'package:flutter/material.dart';

class SpotSsid extends StatelessWidget {
  final String _ssid;

  SpotSsid(this._ssid);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      child: Text(
        _ssid,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
