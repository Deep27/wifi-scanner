class SpotData {

  final String _ssid;
  final String _bssid;
  final int _level;
  final int _frequency;

  SpotData(this._ssid, this._bssid, this._level, this._frequency);
  SpotData.fromResult(dynamic channelResult) :
    _ssid = channelResult['SSID'],
    _bssid = channelResult['BSSID'],
    _level = channelResult['level'],
    _frequency = channelResult['frequency'];


  String get ssid => _ssid; 
  String get bssid => _bssid; 
  int get level => _level; 
  int get frequency => _frequency;

  static List<SpotData> fromResults(List<Map<String, dynamic>> channelResults) {
    List<SpotData> spotsData = channelResults.map((r) => SpotData.fromResult(r)).toList();
    spotsData.sort((a, b) => b.level.compareTo(a.level));
    return spotsData;
  }
} 
