import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi_scanner/widget/wifi_spot_list_element.dart';

final Logger _log = Logger();

class HomePage extends StatefulWidget {
  String ssid;
  int level;
  String ip;
  var result;
  List<WifiResult> wifiResults;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _ssid = 'Fetching SSID';

  // String ssid = await Wifi.ssid;
  // int level = await Wifi.level;
  // String ip = await Wifi.ip;
  // var result = Wifi.connection('ssid', 'password');
  // List<WifiResult> list = await Wifi.list('key');

  @override
  initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    _log.i('SSID: $_ssid');
    String ssid = await Wifi.ssid;
    setState(() {
      _ssid = ssid;
    });
    _log.i('SSID: $_ssid');
  }

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
            WifiSpotListElement(_ssid),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => _fetchData(),
      ),
    );
  }
}
