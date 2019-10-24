final String tableName = 'users';
final String columnLogin = 'login';
final String columnBranch = 'branch';
final String columnDeviceId = 'deviceId';

class User {
  String _login;
  String _branch;
  String _deviceId;

  User.fromMap(Map<String, String> map) {
    _login = map[columnLogin];
    _branch = map[columnBranch];
    _deviceId = map[columnDeviceId];
  }

  Map<String, String> toMap() => {
        columnLogin: _login,
        columnBranch: _branch,
        columnDeviceId: _deviceId,
      };
}
