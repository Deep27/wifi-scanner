class User {

  static final tableName = 'users';
  static final columnId = 'id';
  static final columnLogin = 'login';
  static final columnBranch = 'branch';
  static final columnGosb = 'gosb';
  static final columnDeviceSerialId = 'deviceSerialId';
  static final columnLat = 'lat';
  static final columnLng = 'lng';

  int _id;
  String _login;
  String _branch;
  String _gosb;
  String _deviceSerialId;
  double _lat = 77.77777;
  double _lng = 88.88888;

  int get id => _id;
  String get login => _login;
  String get branch => _branch;
  String get gosb => _gosb;
  String get deviceSerialId => _deviceSerialId;
  double get lat => _lat;
  double get lng => _lng;

  set id(int id) => _id = id;
  set login(String login) => _login = login;
  set branch(String branch) => _branch = branch;
  set gosb(String gosb) => _gosb = gosb;
  set deviceSerialId(String deviceSerialId) => _deviceSerialId = deviceSerialId;
  set lat(double lat) => _lat = lat;
  set lng(double lng) => _lng = lng;

  User.fromMap(Map<String, dynamic> map) {
    _id = map[columnId];
    _login = map[columnLogin];
    _branch = map[columnBranch];
    _gosb = map[columnGosb];
    _deviceSerialId = map[columnDeviceSerialId];
    _lat = 77.77777;
    _lng = 88.88888;
  }

  toMap() {
    final map = <String, dynamic>{
      columnLogin: _login,
      columnBranch: _branch,
      columnGosb: _gosb,
      columnDeviceSerialId: _deviceSerialId,
      'location': {
        columnLat: _lat,
        columnLng: _lng,
      }
    };
    if (_id != null) {
      map[columnId] = _id;
    }
    return map;
  }
}
