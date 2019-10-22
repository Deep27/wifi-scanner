import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:wifi_scanner/model/spot_data.dart';
import 'package:wifi_scanner/permission_handler.dart';
import 'package:wifi_scanner/widget/deviceinfo.dart';
import 'package:wifi_scanner/widget/speedtest.dart';
import 'package:wifi_scanner/widget/spot_item/spot_list_item.dart';

final Logger _LOG = Logger();

class SpotsPage extends StatefulWidget {
  @override
  _SpotsPageState createState() => _SpotsPageState();
}

class _SpotsPageState extends State<SpotsPage> {
  static const platform = const MethodChannel('network/wifi');

  String _platformVersion = 'Unknown';
  final Map<String, double> _speedtestResults = {
    'kilobits': 0,
    'megabits': 0,
    'kilobytes': 0,
    'megabytes': 0
  };
  AndroidDeviceInfo _deviceInfo;

  final List<SpotData> _spotsData = [];

  void _initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await SimplePermissions.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version';
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void _fetchSpotsData() async {
    List<Map<String, dynamic>> scanResults = [];
    try {
      List<dynamic> result = await platform.invokeMethod('scan');
      scanResults = result
          .cast<Map<dynamic, dynamic>>()
          .map((r) => r.cast<String, dynamic>())
          .toList();
      setState(() {
        _spotsData.clear();
        _spotsData.addAll(SpotData.fromResults(scanResults));
      });
    } on PlatformException {
      _LOG.e('Error');
      scanResults.clear();
    }
  }

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
  void initState() {
    super.initState();
    _initPlatformState();
    _getDeviceInfo();
  }

  _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo adf = await deviceInfo.androidInfo;
    setState(() {
      _deviceInfo = adf;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wi-Fi Scanner'),
      ),
      body: Column(
        children: <Widget>[
          DeviceInfoWidget('${_deviceInfo.brand} ${_deviceInfo.model}', _platformVersion),
          SpeedtestWidget(_speedtestResults),
          Expanded(
            child: Container(
              width: double.infinity,
              child: ListView.builder(
                itemBuilder: (ctx, index) => SpotListElement(_spotsData[index]),
                itemCount: _spotsData.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.refresh),
            tooltip: 'scan networks',
            onPressed: () async {
              var accessFineLocationPermissionGranted =
                  await PermissionHandler.checkPermission(
                      Permission.AccessFineLocation);
              if (accessFineLocationPermissionGranted) {
                _fetchSpotsData();
              } else {
                await PermissionHandler.requestPermission(
                    Permission.AccessFineLocation);
              }
            },
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            child: Icon(Icons.file_download),
            tooltip: 'speedtest',
            onPressed: _speedtest,
          ),
        ],
      ),
    );
  }
}
