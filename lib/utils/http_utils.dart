import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_scanner/model/mappable.dart';
import 'package:wifi_scanner/model/profile.dart';
import 'package:wifi_scanner/model/user.dart';

abstract class HttpUtils {
  static final _LOG = Logger();

  static const _URL_BASE = 'wifi-analyzer.4qube.ru';
  static const _URL_REGISTER = '/api/register';
  static const _URL_DEVICES_DATA = '/api/devices/data';
  static const _METHOD = 'http';
  static const _HEADERS = const {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.hostHeader: _URL_BASE
  };

  // /api/register

  static _httpPost(String body, String rest) async =>
      await post('$_METHOD://$_URL_BASE$rest', headers: _HEADERS, body: body);

  static registerUser(User user) async =>
      await _httpPost(json.encode(user.toMap()), _URL_REGISTER);

  static sendScanResults() => null;
}
