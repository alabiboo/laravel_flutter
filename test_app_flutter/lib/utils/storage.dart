import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

class Storage {
  static Future<dynamic> getStringValue(String key) async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    var value = _sharedPreferences.getString(key);
    if (value == null) {
      return null;
    }
    return jsonDecode(value);
  }

  static setString(String key, dynamic value) async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString(key, jsonEncode(value));
  }

  static Future<bool> clear() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.clear();
  }
}
