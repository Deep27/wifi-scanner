import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:wifi_scanner/bloc/networks_scan/networks_scan_event.dart';
import 'package:wifi_scanner/bloc/networks_scan/networks_scan_state.dart';
import 'package:wifi_scanner/permission_handler.dart';

class NetworksScanBloc extends Bloc<NetworksScanEvent, NetworksScanState> {
  static const _platform = const MethodChannel('network/wifi');

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
        result = result
            .cast<Map<dynamic, dynamic>>()
            .map((r) => r.cast<String, dynamic>())
            .toList();
        yield ScanSuccess(result);
      } on PlatformException {
        yield ScanError('Error while scanning networks.');
      }
    }
  } 
}
