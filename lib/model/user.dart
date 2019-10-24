class User {
  static final String tableName = 'users';
  static final String columnId = 'id';
  static final String columnLogin = 'login';
  static final String columnBranch = 'branch';
  static final String columnGosp = 'gosp';
  static final String columnDeviceId = 'deviceId';

  int _id;
  String _login;
  String _branch;
  String _gosp;
  String _deviceId;

  int get id => _id;
  String get login => _login;
  String get branch => _branch;
  String get gosp => _gosp;
  String get deviceId => _deviceId;

  set id(int id) => _id = id;
  set login(String login) => _login = login;
  set branch(String branch) => _branch = branch;
  set gosp(String gosp) => _gosp = gosp;
  set deviceId(String deviceId) => _deviceId = deviceId;

  User.fromMap(Map<String, dynamic> map) {
    _id = map[columnId];
    _login = map[columnLogin];
    _branch = map[columnBranch];
    _gosp = map[columnGosp];
    _deviceId = map[columnDeviceId];
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      columnLogin: _login,
      columnBranch: _branch,
      columnGosp: _gosp,
      columnDeviceId: _deviceId,
    };
    if (_id != null) {
      map[columnId] = _id;
    }
    return map;
  }
}
