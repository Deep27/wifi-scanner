import 'dart:io';

import 'package:flutter/material.dart';
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
      appBar: AppBar(title: const Text('Информация об устройстве')),
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
              Text(
                  'Device model: ${(Platform.isAndroid) ? _deviceInfo.androidDeviceInfo.model : _deviceInfo.iosDeviceInfo.model}'),
              Text(
                  'Platform version: ${(Platform.isAndroid) ? _deviceInfo.platformVersion : _deviceInfo.iosDeviceInfo.systemVersion}'),
              Text(
                  'Device ID: ${(Platform.isAndroid) ? _deviceInfo.androidDeviceInfo.androidId : _deviceInfo.iosDeviceInfo.identifierForVendor}'),
            ],
          ),
        ),
      );
}
