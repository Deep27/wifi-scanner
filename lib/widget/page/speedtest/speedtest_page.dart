import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

final _LOG = Logger();

class SpeedtestPage extends StatefulWidget {
  @override
  _SpeedtestPageState createState() => _SpeedtestPageState();
}

class _SpeedtestPageState extends State<SpeedtestPage> {
  static const platform = const MethodChannel('network/wifi');

  Map<String, double> _speedtestResults = {
    'kilobits': 0,
    'megabits': 0,
    'kilobytes': 0,
    'megabytes': 0
  };

  void _speedtest() async {
    Map<String, double> speedtestResults;
    try {
      speedtestResults = await platform.invokeMapMethod('speedtest');
      setState(() {
        _speedtestResults.clear();
        _speedtestResults.addAll(speedtestResults);
      });
    } on PlatformException {
      _LOG.e('Error');
    }
    _LOG.i('SpeedTest results: ${speedtestResults.toString()}');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Speedtest')),
        body: _getBody(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.file_download),
          label: Text('Speedtest'),
          tooltip: 'speedtest',
          onPressed: _speedtest,
        ),
      );

  _getBody() => Column(
        children: <Widget>[
          Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      'Speedtest results',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('kbps: ${_speedtestResults['kilobits']}'),
                          Text('mbps: ${_speedtestResults['megabits']}')
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('kBps: ${_speedtestResults['kilobytes']}'),
                          Text('mBps: ${_speedtestResults['megabytes']}')
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // here will be speedometer
        ], 
      );
}
