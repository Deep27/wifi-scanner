import 'package:connectivity/connectivity.dart';

class CurrentNetworkUtils {

  String bssid;
  String wifiIp;
  String wifiName;

  CurrentNetworkUtils.privateConstructor(); 

  static CurrentNetworkUtils _instance;
  static Future<CurrentNetworkUtils> get instance async {
    if (_instance == null) {
      _instance = await _init();
    }
    return _instance;
  } 

  static Future<CurrentNetworkUtils> _init() async {
    CurrentNetworkUtils instance = CurrentNetworkUtils.privateConstructor();
    instance.bssid = await (Connectivity().getWifiBSSID());
    instance.wifiIp = await (Connectivity().getWifiIP());
    instance.wifiName = await (Connectivity().getWifiName()); 
    return instance;
  }
}
