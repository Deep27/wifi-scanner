import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';

class DeviceInfoPage extends StatefulWidget {
  @override
  _DeviceInfoPageState createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  AndroidDeviceInfo _deviceInfo;
  String _platformVersion = 'Unknown';

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

  Center _getBody() => Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: <Widget>[
              Text('Device model: ${_deviceInfo.model}'),
              Text('Platform version: $_platformVersion')
            ],
          ),
        ),
      );
}
