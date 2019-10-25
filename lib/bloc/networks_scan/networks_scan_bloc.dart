import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:wifi_scanner/bloc/networks_scan/networks_scan_event.dart';
import 'package:wifi_scanner/bloc/networks_scan/networks_scan_state.dart';
import 'package:wifi_scanner/model/scan_result.dart';
import 'package:wifi_scanner/permission_handler.dart';
import 'package:wifi_scanner/utils/current_network_utils.dart';
import 'package:wifi_scanner/utils/http_utils.dart';

final _LOG = Logger();

class NetworksScanBloc extends Bloc<NetworksScanEvent, NetworksScanState> {
  static const _platform = const MethodChannel('network/wifi');

  static int lastUpdate = -1;
  static int interval = 60 * 60;

  static Timer timer;

  SharedPreferences _prefs;

  NetworksScanBloc() {
    _initPrefs();
  }

  _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  NetworksScanState get initialState => InitialNetworksScanState();

  @override
  Stream<NetworksScanState> mapEventToState(NetworksScanEvent event) async* {
    if (event is StartScan) {
      yield ScanningNetworks();
      var accessFineLocationPermissionGranted =
          await PermissionHandler.checkPermission(
              Permission.AccessFineLocation);
      if (!accessFineLocationPermissionGranted) {
        yield ScanError('You must enable location service!');
        return;
      }
      try {
        List<dynamic> result = await _platform.invokeMethod('scan');
        var wait = await Future.delayed(Duration(seconds: 1, milliseconds: 500),
            () {}); // @TODO remove this line
        result = result
            .cast<Map<dynamic, dynamic>>()
            .map((r) => r.cast<String, dynamic>())
            .toList();
        result.sort(
            (m1, m2) => (m2['level'] as int).compareTo((m1['level'] as int)));
        result = result
            .map((r) => ScanResult(
                ssid: r['SSID'],
                level: r['level'],
                bssid: r['BSSID'],
                frequency: r['frequency'],
                bandwidth: r['channelWidth'],
                timestamp: r['timestamp']))
            .toList();

        int time = DateTime.now().millisecondsSinceEpoch;
        int profileUpdatedAt = 10000;
        String profileCode = json.decode(_prefs.getString('profile'))['code'];
        Map user = json.decode(_prefs.getString('user'));
        user.remove('deviceSerialId');
        user['lat'] = user['location']['lat'];
        user['lng'] = user['location']['lng'];
        user.remove('location');
        Map deviceInfo = {
          'deviceSerialId':
              json.decode(_prefs.getString('user'))['deviceSerialId'],
          'platformVersion': _prefs.getString('platformVersion'),
          'platform': _prefs.getString('platform'),
          'deviceModel': _prefs.getString('deviceModel')
        };
        List<Map> networksAvailable = [];
        result.forEach((r) => networksAvailable.add((r as ScanResult).toMap()));

        CurrentNetworkUtils cnu = await CurrentNetworkUtils.instance;
        String usedSsid = cnu.wifiName;
        String usedBssid = cnu.bssid;

        Map usedNetwork = networksAvailable.firstWhere((n) =>
            n[ScanResult.columnSsid] == usedSsid &&
            n[ScanResult.columnBssid] == usedBssid);

        Map requestBody = {
          'time': time,
          'profileUpdatedAt': profileUpdatedAt,
          'profileCode': profileCode,
          'user': user,
          'deviceInfo': deviceInfo,
          'networksAvailable': networksAvailable,
          'usedNetwork': usedNetwork,
        };

        // send data or save to db
        Response response = await HttpUtils.sendScanResults(requestBody);

        int statusCode = response.statusCode;
        if (statusCode == 200) {
          _LOG.i(response.body);
          int lastProfileUpdate = json.decode(_prefs.getString('profile'))['updateAt'];
          int newInterval = json.decode(_prefs.getString('profile'))['updatePeriod'];
          if (lastProfileUpdate != lastUpdate) {
            _LOG.i('Profile updated! New interval: $newInterval');
            lastUpdate = lastProfileUpdate;
            // interval = profile['updatePeriod'];
            interval = newInterval;
            // timer = Timer.periodic(Duration(seconds: interval), (t) => scan());
          }
          yield ScanSuccess(result, interval);
        } else {
          _LOG.e(response.body);
          yield ScanError(response.body);
        }
      } on PlatformException {
        yield ScanError('Error while scanning networks.');
      }
    }
  }

  _testSpeed() {}

  _testAwailability() {}
}
