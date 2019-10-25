import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_scanner/model/device_info.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences initShareStatePrefs;
  DeviceInfo _deviceInfo;

  var data = [0.0, 1.0, 3.0, 4.0, 7.0, 8.0, 9.0, 5.0, 10.0, 5.0, 12.0];
  var data1 = [0.0, -2.0, 3.5, -2.0, 0.5, 0.7, 0.8, 1.0, 2.0, 3.0, 3.2];

  List<CircularStackEntry> circularData = <CircularStackEntry>[
    new CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(18.0, Color(0xffec3337), rankKey: 'BAD'),
        new CircularSegmentEntry(10.0, Color(0xff40b24b), rankKey: 'GOOD'),
      ],
      rankKey: 'Quarterly Profits',
    ),
  ];

  Material myTextItems(String title, String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 400
                            ? 20.0
                            : 12.0,
                        fontWeight: MediaQuery.of(context).size.width > 400
                            ? FontWeight.normal
                            : FontWeight.bold,
                        //fontSize: 20.0,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 400
                            ? 30.0
                            : 15.0,
                        //fontSize: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material myCircularItems(String title, String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 400
                            ? 20.0
                            : 12.0,
                        fontWeight: MediaQuery.of(context).size.width > 400
                            ? FontWeight.normal
                            : FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AnimatedCircularChart(
                      size: const Size(100.0, 100.0),
                      initialChartData: circularData,
                      chartType: CircularChartType.Pie,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      MediaQuery.of(context).size.width > 400
                          ? "Доступно - 10/Не доступно - 20"
                          : "Доступно - 10\nНе доступно - 20",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 400
                            ? 15.0
                            : 10.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material mychart1Items(String title, String priceVal, String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 400
                            ? 20.0
                            : 12.0,
                        fontWeight: MediaQuery.of(context).size.width > 400
                            ? FontWeight.normal
                            : FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      priceVal,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 400
                            ? 30.0
                            : 20.0,
                        //fontSize: 30.0,
                      ),
                    ),
                  ),
                  MediaQuery.of(context).size.width > 400
                      ? Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blueGrey,
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 5.0,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: new Sparkline(
                      data: data,
                      lineColor: Color(0xffff6101),
                      pointsMode: PointsMode.all,
                      pointSize: 8.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material mychartDeviceInfo(String title) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(.0),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 400
                                ? 20.0
                                : 12.0,
                            fontWeight: MediaQuery.of(context).size.width > 400
                                ? FontWeight.normal
                                : FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      child: Text(
                        "Модель устройства:",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 400
                              ? 20.0
                              : 12.0,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      child: Text(
                        "Платформа:",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 400
                              ? 20.0
                              : 12.0,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      child: Text(
                        "ID Устройства:",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 400
                              ? 20.0
                              : 12.0,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      child: Text(
                        "IP Устройства:",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 400
                              ? 20.0
                              : 12.0,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      child: Text(
                        '${(Platform.isAndroid) ? _deviceInfo.androidDeviceInfo.model : _deviceInfo.iosDeviceInfo.model}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 400
                              ? 20.0
                              : 12.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      child: Text(
                        '${(Platform.isAndroid) ? _deviceInfo.platformVersion : _deviceInfo.iosDeviceInfo.systemVersion}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 400
                              ? 20.0
                              : 12.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      child: Text(
                        '${(Platform.isAndroid) ? _deviceInfo.androidDeviceInfo.androidId : _deviceInfo.iosDeviceInfo.identifierForVendor}',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 400
                              ? 20.0
                              : 8.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      child: Text(
                        '192.168.0.1',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 400
                              ? 20.0
                              : 12.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Material mychart2Items(String title) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 400
                            ? 20.0
                            : 12.0,
                        fontWeight: MediaQuery.of(context).size.width > 400
                            ? FontWeight.normal
                            : FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),

                  IconButton(
                      icon: Icon(
                        FontAwesomeIcons.toolbox,
                        size: 30.0,
                      ),
                      onPressed: () {
                        //TODO:ПЕРЕХОД К РОМЕ
                      }),

//                  Padding(
//                    padding: EdgeInsets.all(1.0),
//                    child: new Sparkline(
//                      data: data1,
//                      fillMode: FillMode.below,
//                      fillGradient: new LinearGradient(
//                        begin: Alignment.topCenter,
//                        end: Alignment.bottomCenter,
//                        colors: [Colors.amber[800], Colors.amber[200]],
//                      ),
//                    ),
//                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material editParams(String title) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 400
                            ? 20.0
                            : 12.0,
                        fontWeight: MediaQuery.of(context).size.width > 400
                            ? FontWeight.normal
                            : FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        FontAwesomeIcons.edit,
                        size: 30.0,
                      ),
                      onPressed: () {
                        //TODO:ПЕРЕХОД К РОМЕ
                      }),

//                  Padding(
//                    padding: EdgeInsets.all(1.0),
//                    child: new Sparkline(
//                      data: data1,
//                      fillMode: FillMode.below,
//                      fillGradient: new LinearGradient(
//                        begin: Alignment.topCenter,
//                        end: Alignment.bottomCenter,
//                        colors: [Colors.amber[800], Colors.amber[200]],
//                      ),
//                    ),
//                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              //
            }),
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.chartLine),
              onPressed: () {
                //
              }),
        ],
      ),
      body: Container(
        color: Color(0xffE5E5E5),
        child: StaggeredGridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: mychart1Items(
                  "Количество подключенных устройств в ВСП № ${json.decode(initShareStatePrefs.getString("user"))["branch"]}\n",
                  "12",
                  ""),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: myCircularItems(
                  MediaQuery.of(context).size.width > 400
                      ? "Доступность ресурсов"
                      : "Доступность\n   ресурсов",
                  ""),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: myTextItems(
                  MediaQuery.of(context).size.width > 400
                      ? "Ср.входящее соединение"
                      : "Ср.входящее\nсоединение",
                  "1.61 МБайт/с"),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: myTextItems(
                  MediaQuery.of(context).size.width > 400
                      ? "Ср.исходящее соединение"
                      : "Ср.исходящее\nсоединение",
                  "868.28 КБайт/с"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: mychartDeviceInfo("Информация об устройстве"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: editParams(MediaQuery.of(context).size.width > 400
                  ? "Редактирование настроек"
                  : "Редактирование\n       настроек"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: mychart2Items("Инструментарий"),
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(4, 250.0),
            StaggeredTile.extent(2, 250.0),
            StaggeredTile.extent(2, 120.0),
            StaggeredTile.extent(2, 120.0),
            StaggeredTile.extent(4, 250.0),
            StaggeredTile.extent(2, 150.0),
            StaggeredTile.extent(2, 150.0),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    initStatePrefs();
    _getDeviceInfo();
    super.initState();
  }

  initStatePrefs() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      initShareStatePrefs = sharedPreferences;
    });
  }

  _getDeviceInfo() async {
    DeviceInfo deviceInfo = await DeviceInfo.instance;
    setState(() {
      _deviceInfo = deviceInfo;
    });
  }
}
