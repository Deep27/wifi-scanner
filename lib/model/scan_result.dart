import 'package:flutter/foundation.dart';

class ScanResult {

  static final tableName = 'scanResults';
  static final columnSsid = 'ssid';
  static final columnLevel = 'level';
  static final columnBssid = 'bssid';
  static final columnFrequency = 'frequency';
  static final columnChannels = 'channels';
  static final columnTimestamp = 'timestamp';

  String ssid;
  int level;
  String bssid;
  int frequency;
  int bandwidth;
  List<int> channels;
  int timestamp;

  ScanResult({@required this.ssid, @required this.level, @required this.bssid, @required this.frequency, @required this.bandwidth, @required this.timestamp}) { 
    channels = _getChannels(frequency);
  }

  ScanResult.fromMap(Map map) {
    ssid = map[columnSsid];
    level = map[columnLevel];
    bssid = map[columnBssid];
    frequency = map[columnFrequency];
    channels = map[columnChannels];
    timestamp = map[columnTimestamp];
  }

  @override
  toMap() => {
    columnSsid: ssid,
    columnLevel: level,
    columnBssid: bssid,
    columnFrequency: frequency,
    columnChannels: channels,
    columnTimestamp: timestamp
  }; 

  List<int> _getChannels(int frequency) { 
    int frequencyGghz = frequency ~/ 1000;
    Map<int, int> map;
    if (frequencyGghz == 2) {
      map = _frequencyChannel2ghzMap;
    } else if (frequencyGghz == 5) {
      map = _frequencyChannel5ghzMap;
    }
    int freqRange = _bandwidthFreqMap[bandwidth];
    int min = frequency - (freqRange ~/ 2);
    int max = frequency + (freqRange ~/ 2);
    Map<int, int> usedFreqsMap = Map.from(map);
    usedFreqsMap.removeWhere((k, v) => v < min || v > max);
    return usedFreqsMap.keys.toList();
  }

  final _bandwidthFreqMap = const {
    0: 20, 1: 40, 2: 80, 3: 160,
    4: 160 // 80 + 80
  };

  final _frequencyChannel5ghzMap = const {
    36: 5180, 40: 5200, 44: 5220, 48: 5240,
    52: 5260, 56: 5280, 60: 5300, 64: 5320,
    100: 5500, 104: 5520, 108: 5540, 112: 5560,
    116: 5580, 120: 5600, 124: 5620, 128: 5640,
    132: 5600, 136: 5680, 140: 5700, 149: 5745,
    153: 5765, 157: 5785, 161: 5805, 165: 5825
  };

  final _frequencyChannel2ghzMap = const {
    1: 2401, 2: 2406, 3: 2411, 4: 2416,
    5: 2421, 6: 2426, 7: 2431, 8: 2436,
    9: 2441, 10: 2446, 11: 2451, 12: 2456,
    13: 2461, 14: 2473
  };
}