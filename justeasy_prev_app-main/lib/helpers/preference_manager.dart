import 'package:flutter/widgets.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static const String AUTHORIZATION_TOKEN = 'access-token';
  static const String REFRESH_TOKEN = 'refresh-token';
  static const String IS_FIRST_TIME = 'isFirst';

  final SharedPreferences _preferences;
  // bool _initialised = false;

  PreferenceManager(this._preferences);

  // void setPreference(value){
  //   _preferences = value;
  //   _initialised = true;
  // }
  // bool get isReady{
  //   return _initialised;
  // }

  SharedPreferences get getInstance {
    return _preferences;
  }

  set token(token) {
    _preferences.setString(
        PreferenceManager.AUTHORIZATION_TOKEN, token['accessToken'] ?? '');
    _preferences.setString(
        PreferenceManager.REFRESH_TOKEN, token['refreshToken'] ?? '');
  }

  String get accessToken {
    return _preferences.getString(PreferenceManager.AUTHORIZATION_TOKEN) ?? '';
  }

  static Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    PreferenceManager manager = PreferenceManager(preferences);

    return manager.accessToken;
  }

  void logout() {
    _preferences.setString(PreferenceManager.AUTHORIZATION_TOKEN, '');
    _preferences.setString(PreferenceManager.REFRESH_TOKEN, '');
  }
}
