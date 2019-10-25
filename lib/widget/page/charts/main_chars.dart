import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_scanner/model/device_info.dart';
import 'package:wifi_scanner/route/router.dart';
import 'package:wifi_scanner/utils/current_network_utils.dart';
import 'package:wifi_scanner/widget/page/spots/spots_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences initShareStatePrefs;
  DeviceInfo _deviceInfo;
  CurrentNetworkUtils _currentNetworkUtils;

  String currentProfilePic = "https://avatars3.githubusercontent.com/u/16825392?s=460&v=4";
  String otherProfilePic = "https://yt3.ggpht.com/-2_2skU9e2Cw/AAAAAAAAAAI/AAAAAAAAAAA/6NpH9G8NWf4/s900-c-k-no-mo-rj-c0xffffff/photo.jpg";

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
                        fontSize: MediaQuery.of(context).size.width > 470
                            ? 20.0
                            : 12.0,
                        fontWeight: MediaQuery.of(context).size.width > 470
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
                        fontSize: MediaQuery.of(context).size.width > 470
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
                        fontSize: MediaQuery.of(context).size.width > 470
                            ? 20.0
                            : 12.0,
                        fontWeight: MediaQuery.of(context).size.width > 470
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
                      MediaQuery.of(context).size.width > 470
                          ? "Доступно - 10/Не доступно - 20"
                          : "Доступно - 10\nНе доступно - 20",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 470
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
                        fontSize: MediaQuery.of(context).size.width > 470
                            ? 20.0
                            : 12.0,
                        fontWeight: MediaQuery.of(context).size.width > 470
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
                        fontSize: MediaQuery.of(context).size.width > 470
                            ? 30.0
                            : 20.0,
                        //fontSize: 30.0,
                      ),
                    ),
                  ),
                  MediaQuery.of(context).size.width > 470
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
                            fontSize: MediaQuery.of(context).size.width > 470
                                ? 20.0
                                : 12.0,
                            fontWeight: MediaQuery.of(context).size.width > 470
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
                          fontSize: MediaQuery.of(context).size.width > 470
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
                          fontSize: MediaQuery.of(context).size.width > 470
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
                          fontSize: MediaQuery.of(context).size.width > 470
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
                          fontSize: MediaQuery.of(context).size.width > 470
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
                          fontSize: MediaQuery.of(context).size.width > 470
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
                          fontSize: MediaQuery.of(context).size.width > 470
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
                          fontSize: MediaQuery.of(context).size.width > 470
                              ? 20.0
                              : Platform.isAndroid ? 12 :8.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      child: Text(
                        _currentNetworkUtils.wifiIp,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 470
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
                        fontSize: MediaQuery.of(context).size.width > 470
                            ? 20.0
                            : 12.0,
                        fontWeight: MediaQuery.of(context).size.width > 470
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
                        Navigator.of(context).push(Router.createRoute(SpotsPage()));
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
                        fontSize: MediaQuery.of(context).size.width > 470
                            ? 20.0
                            : 12.0,
                        fontWeight: MediaQuery.of(context).size.width > 470
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
        title: Text(widget.title),
//        actions: <Widget>[
//          IconButton(
//              icon: Icon(FontAwesomeIcons.chartLine),
//              onPressed: () {
//                //
//              }),
//        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              //accountEmail: new Text("bramvbilsen@gmail.com"),
              accountName: new Text("Артем Соковец", style: TextStyle(color: Colors.white),),
              currentAccountPicture: new GestureDetector(
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage(currentProfilePic),
                ),
              ),
              otherAccountsPictures: <Widget>[

              ],
//              decoration: new BoxDecoration(
//                  image: new DecorationImage(
//                      image: new NetworkImage("https://img00.deviantart.net/35f0/i/2015/018/2/6/low_poly_landscape__the_river_cut_by_bv_designs-d8eib00.jpg"),
//                      fit: BoxFit.fill
//                  )
//              ),
            ),
            new ListTile(
                title: new Text("Тестирование сети"),
                trailing: new Icon(Icons.apps),
                onTap: () {
                  Navigator.of(context).pop();
                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("Second Page")));
                }
            ),
            new ListTile(
                title: new Text("Изменение ВСП"),
                trailing: new Icon(Icons.edit),
                onTap: () {
                  Navigator.of(context).pop();
                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("First Page")));
                }
            ),
            new ListTile(
                title: new Text("Смена пользователя"),
                trailing: new Icon(Icons.supervised_user_circle),
                onTap: () {
                  Navigator.of(context).pop();
                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("First Page")));
                }
            ),
            new ListTile(
                title: new Text("Выход"),
                trailing: new Icon(Icons.exit_to_app),
                onTap: () {
                  Navigator.of(context).pop();
                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("First Page")));
                }
            ),
            new Divider(),
            new ListTile(
              title: new Text("На главную страницу"),
              trailing: new Icon(Icons.cancel),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
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
                  MediaQuery.of(context).size.width > 470
                      ? "Доступность ресурсов"
                      : "Доступность\n   ресурсов",
                  ""),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: myTextItems(
                  MediaQuery.of(context).size.width > 470
                      ? "Ср.входящее соединение"
                      : "Ср.входящее\nсоединение",
                  "1.61 МБайт/с"),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: myTextItems(
                  MediaQuery.of(context).size.width > 470
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
              child: editParams(MediaQuery.of(context).size.width > 470
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
    _init();
    super.initState();
  }

  initStatePrefs() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      initShareStatePrefs = sharedPreferences;
    });
  }

  _init() async {
    DeviceInfo deviceInfo = await DeviceInfo.instance;
    CurrentNetworkUtils currentNetworkUtils = await CurrentNetworkUtils.instance;
    setState(() {
      _deviceInfo = deviceInfo;
      _currentNetworkUtils = currentNetworkUtils;
    });
  }
}
