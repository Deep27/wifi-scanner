
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';

class DeviceInfo {
  AndroidDeviceInfo _androidDeviceInfo;
  String _platformVersion;

  AndroidDeviceInfo get androidDeviceInfo => _androidDeviceInfo;
  String get platformVersion => _platformVersion;

  DeviceInfo._privateConstructor();

  static DeviceInfo _instance;

  static Future<DeviceInfo> get instance async {
    if (_instance != null) {
      return _instance;
    }
    _instance = await _init();
    return _instance;
  }

  static Future<DeviceInfo> _init() async {
    DeviceInfo instance = DeviceInfo._privateConstructor();
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo adf = await plugin.androidInfo;
    instance._androidDeviceInfo = adf;
    String platformVersion;
    try {
      platformVersion = await SimplePermissions.platformVersion; 
    } on PlatformException {
      platformVersion = 'Unknown';
    }
    instance._platformVersion = platformVersion;
    return instance;
  }
}