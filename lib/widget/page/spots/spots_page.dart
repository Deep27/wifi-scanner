import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_scanner/bloc/networks_scan/networks_scan_bloc.dart';
import 'package:wifi_scanner/bloc/networks_scan/networks_scan_event.dart';
import 'package:wifi_scanner/bloc/networks_scan/networks_scan_state.dart';
import 'package:wifi_scanner/model/spot_data.dart';
import 'package:wifi_scanner/route/router.dart';
import 'package:wifi_scanner/widget/page/device_info/deviceinfo_page.dart';
import 'package:wifi_scanner/widget/page/speedtest/speedtest_page.dart';
import 'package:wifi_scanner/widget/page/spots/spot_item/spot_list_item.dart';

final Logger _LOG = Logger();

class SpotsPage extends StatefulWidget {
  SpotsPage({Key key}) : super(key: key);

  @override
  _SpotsPageState createState() => _SpotsPageState();
}

class _SpotsPageState extends State<SpotsPage> {
  final networksScanBloc = NetworksScanBloc();
  SharedPreferences _prefs;

  @override
  void initState() {
    _initPrefs();
    super.initState();
  }

  _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    super.dispose();
    networksScanBloc.close();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _getAppBar(),
        body: _getBody(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: BlocProvider<NetworksScanBloc>(
          builder: (context) => networksScanBloc,
          child: BlocBuilder<NetworksScanBloc, NetworksScanState>(
            bloc: networksScanBloc,
            builder: (BuildContext context, NetworksScanState state) {
              return FloatingActionButton.extended(
                icon: Icon(Icons.refresh),
                label: Text('Scan'),
                tooltip: 'scan networks',
                onPressed: () {
                  final networksScanBloc =
                      BlocProvider.of<NetworksScanBloc>(context);
                  networksScanBloc.add(StartScan());
                },
              );
            },
          ),
        ),
      );

  _getBody() => BlocProvider<NetworksScanBloc>(
        builder: (context) => networksScanBloc,
        child: BlocBuilder<NetworksScanBloc, NetworksScanState>(
          bloc: networksScanBloc,
          builder: (BuildContext context, NetworksScanState state) {
            if (state is ScanSuccess) {
              return Container(
                width: double.infinity,
                child: ListView.builder(
                  itemBuilder: (ctx, index) => SpotListItem(state.scanResults[index]),
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
      );

  _getAppBar() => AppBar(
        title: const Text('Sberbank Intermeter'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () =>
                Navigator.of(context).push(Router.createRoute(SpeedtestPage())),
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => Navigator.of(context)
                .push(Router.createRoute(DeviceInfoPage())),
          ),
        ],
      );
}
