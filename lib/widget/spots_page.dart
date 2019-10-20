import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:wifi_scanner/model/spot_data.dart';
import 'package:wifi_scanner/permission_handler.dart';
import 'package:wifi_scanner/widget/spot_list_element.dart';

final Logger _LOG = Logger();

class SpotsPage extends StatefulWidget {
  @override
  _SpotsPageState createState() => _SpotsPageState();
}

class _SpotsPageState extends State<SpotsPage> {
  static const platform = const MethodChannel('scanner/scan');

  String _platformVersion = 'Unknown';

  final List<SpotData> _spotsData = [SpotData("SSID", -1)];

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
    List ssids;
    try {
      ssids = await platform.invokeMethod('scan');
      _LOG.i('Found SSIDs $ssids');
    } on PlatformException {
      _LOG.e('Error');
      ssids.clear();
    }

    setState(() {
      _spotsData.clear();
      ssids.forEach((ssid) => _spotsData.add(SpotData(ssid, -1))); 
    });
  } 

  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wi-Fi Scanner'),
      ),
      body: Container(
        width: double.infinity,
        child: ListView.builder(
          itemBuilder: (ctx, index) => SpotListElement(_spotsData[index]),
          itemCount: _spotsData.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () async {
          var accessFineLocationPermissionGranted = await PermissionHandler.checkPermission(Permission.AccessFineLocation);
          if (accessFineLocationPermissionGranted) { 
            _fetchSpotsData();
          } else {
            await PermissionHandler.requestPermission(Permission.AccessFineLocation);
          }
        }
      ),
    );
  }
}
