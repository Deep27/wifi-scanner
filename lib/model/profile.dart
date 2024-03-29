class Profile {

  static final tableName = 'profiles';
  static final columnId = 'id';
  static final columnCode = 'code';
  static final columnWifiNetworkSSIDs = 'wifiNetworkSSIDs';
  static final columnAlarmSignal = 'alarmSignal';
  static final columnUpdatePeriod = 'updatePeriod';
  static final columnWebResources = 'webResources';
  static final columnTcpResources = 'tcpResources';
  static final columnUpdateAt = 'updateAt';

  String code;
  int alarmSignal;
  List<String> wifiNetworksSSIDs;
  int updatePeriod;
  List<Map<String, String>> webResources = [];
  List<Map<String, dynamic>> tcpResources = [];
  int updateAt; 

  Profile.fromMap(Map map) {
    code = map[columnCode];
    wifiNetworksSSIDs =
        (map[columnWifiNetworkSSIDs] as List<dynamic>).cast<String>();
    alarmSignal = map[columnAlarmSignal];
    updatePeriod = map[columnUpdatePeriod];
    webResources.addAll((map[columnWebResources] as List<dynamic>)
        .cast<Map<dynamic, dynamic>>()
        .map((r) => r.cast<String, String>())
        .toList());
    tcpResources.addAll((map[columnTcpResources] as List<dynamic>)
        .cast<Map<dynamic, dynamic>>()
        .map((r) => r.cast<String, dynamic>())
        .toList());
    updateAt = DateTime.parse(map[columnUpdateAt]).millisecondsSinceEpoch;
  }

  toMap() => {
      columnCode: code,
      columnAlarmSignal: alarmSignal,
      columnUpdatePeriod: updatePeriod,
      columnWifiNetworkSSIDs: wifiNetworksSSIDs,
      columnWebResources: webResources,
      columnTcpResources: tcpResources,
      columnUpdateAt: updateAt
    }; 

  @override
  String toString() {
    return '''
      $columnCode : $code
      $columnWifiNetworkSSIDs : $wifiNetworksSSIDs
      $columnAlarmSignal : $alarmSignal
      $columnUpdatePeriod : $updatePeriod
      $columnWebResources : $webResources
      $columnTcpResources : $tcpResources
      $columnUpdateAt: $updateAt
    ''';
  }
}
