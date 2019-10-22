import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:wifi_scanner/bloc/networks_scan/networks_scan_bloc.dart';
import 'package:wifi_scanner/bloc/networks_scan/networks_scan_event.dart';
import 'package:wifi_scanner/bloc/networks_scan/networks_scan_state.dart';
import 'package:wifi_scanner/model/spot_data.dart';
import 'package:wifi_scanner/widget/deviceinfo.dart';
import 'package:wifi_scanner/widget/speedtest.dart';
import 'package:wifi_scanner/widget/spot_item/spot_list_item.dart';

final Logger _LOG = Logger();

class SpotsPage extends StatefulWidget {
  SpotsPage({Key key}) : super(key: key);

  @override
  _SpotsPageState createState() => _SpotsPageState();
}

class _SpotsPageState extends State<SpotsPage> {
  static const platform = const MethodChannel('network/wifi');

  final networksScanBloc = NetworksScanBloc();
  final Map<String, double> _speedtestResults = {
    'kilobits': 0,
    'megabits': 0,
    'kilobytes': 0,
    'megabytes': 0
  };

  AndroidDeviceInfo _deviceInfo;
  String _platformVersion = 'Unknown';

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

  @override
  void dispose() {
    super.dispose();
    networksScanBloc.close();
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
      body: BlocProvider<NetworksScanBloc>(
        builder: (context) => networksScanBloc,
        child: Column(
          children: <Widget>[
            DeviceInfoWidget(
                '${_deviceInfo.brand} ${_deviceInfo.model}', _platformVersion),
            SpeedtestWidget(_speedtestResults),
            Expanded(
              child: BlocBuilder<NetworksScanBloc, NetworksScanState>(
                bloc: networksScanBloc,
                builder: (BuildContext context, NetworksScanState state) {
                  if (state is ScanSuccess) {
                    return Container(
                      width: double.infinity,
                      child: ListView.builder(
                        itemBuilder: (ctx, index) => SpotListElement(
                            SpotData.fromResult(state.scanResults[index])),
                        itemCount: state.scanResults.length,
                      ),
                    );
                  } else if (state is ScanningNetworks) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Networks information will be here.',
                        style: TextStyle(fontSize: 25),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BlocProvider<NetworksScanBloc>(
            builder: (context) => networksScanBloc,
            child: BlocBuilder<NetworksScanBloc, NetworksScanState>(
              bloc: networksScanBloc,
              builder: (BuildContext context, NetworksScanState state) {
                return FloatingActionButton.extended( 
                  icon: Icon(Icons.refresh),
                  label: Text('Networks'),
                  tooltip: 'scan networks',
                  onPressed: () {
                    final networksScanBloc = BlocProvider.of<NetworksScanBloc>(context);
                    networksScanBloc.add(StartScan());
                  },
                );
              },
            ),
          ),
          SizedBox(width: 10),
          FloatingActionButton.extended(
            icon: Icon(Icons.file_download),
            label: Text('Speedtest'), 
            tooltip: 'speedtest', 
            onPressed: _speedtest,
          ),
        ],
      ),
    );
  }
}
