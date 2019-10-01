import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi_scanner/widget/wifi_spot_list_element.dart';

final Logger _log = Logger();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _ssid = 'Fetching SSID';
  int _level = -1;
  String _ip = 'Fetching IP';
  var _result;
  final List<WifiResult> _wifiResults = [];

  @override
  initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    _log.i('[Before update] SSID: $_ssid, Level: $_level, IP: $_ip, Results: $_wifiResults');
    String ssid = await Wifi.ssid;
    int level = await Wifi.level;
    String ip = await Wifi.ip;
    // var result = Wifi.connection('ssid', 'password');
    List<WifiResult> results = await Wifi.list('RT-5WiFi-F0FB');
    setState(() {
      _ssid = ssid;
      _level = level;
      _ip = ip;
      // _result = result;
      _wifiResults.clear();
      _wifiResults.addAll(results);
    });
    _log.i('[After update] SSID: $_ssid, Level: $_level, IP: $_ip, Results: $_wifiResults');
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
            WifiSpotListElement(_ssid, _level, _ip, _result, _wifiResults),
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
