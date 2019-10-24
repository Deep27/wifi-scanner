import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:wifi_scanner/model/device_info.dart';

class DeviceInfoPage extends StatefulWidget {
  @override
  _DeviceInfoPageState createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  DeviceInfo _deviceInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Info')),
      body: _getBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  _getDeviceInfo() async {
    DeviceInfo deviceInfo = await DeviceInfo.instance;
    setState(() {
      _deviceInfo = deviceInfo;
    });
  } 

  Center _getBody() => Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: <Widget>[
              Text('Device model: ${_deviceInfo.androidDeviceInfo.model}'),
              Text('Platform version: ${_deviceInfo.platformVersion}'),
              Text('Device ID: ${_deviceInfo.androidDeviceInfo.androidId}'),
            ],
          ),
        ),
      );
}
