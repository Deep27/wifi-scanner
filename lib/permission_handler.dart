
import 'package:logger/logger.dart';
import 'package:simple_permissions/simple_permissions.dart';

class PermissionHandler { 

  static final _LOG = Logger();

  static Future<PermissionStatus> requestPermission(Permission permission) async {
    final res = await SimplePermissions.requestPermission(permission); 
    _LOG.i("Permission ${permission.toString()} request result: $res");
    return res;
  }

  static Future<bool> checkPermission(Permission permission) async {
    final res = await SimplePermissions.checkPermission(permission);
    _LOG.i("Permission ${permission.toString()} status: $res");
    return res;
  }
}
