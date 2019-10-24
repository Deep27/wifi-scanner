import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:wifi_scanner/bloc/networks_scan/networks_scan_event.dart';
import 'package:wifi_scanner/bloc/networks_scan/networks_scan_state.dart';
import 'package:wifi_scanner/model/scan_result.dart';
import 'package:wifi_scanner/permission_handler.dart';
import 'package:wifi_scanner/utils/http_utils.dart';


class NetworksScanBloc extends Bloc<NetworksScanEvent, NetworksScanState> {
  static const _platform = const MethodChannel('network/wifi');

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
        result = result.map((r) => ScanResult(
          ssid: r['SSID'],
          level: r['level'],
          bssid: r['BSSID'],
          frequency: r['frequency'],
          bandwidth: r['channelWidth'],
          timestamp: r['timestamp']
        )).toList();
        yield ScanSuccess(result); 

        int timestamp = DateTime.now().millisecondsSinceEpoch;
        Map deviceInfo = {
          'deviceSerialId': _prefs.getString('deviceSerialId')
        };

        // send data or save to db
        Response response = await HttpUtils.sendScanResults();


      } on PlatformException {
        yield ScanError('Error while scanning networks.');
      }
    }
  }
}
