import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthLocalDataSource {
  Future<String?> readToken();
  Future<void> saveToken(String token);
  Future<void> clear();
}

class SharedPreferencesAuthLocalDataSource implements AuthLocalDataSource {
  SharedPreferencesAuthLocalDataSource(this._preferences);

  final SharedPreferences _preferences;

  static const _key = 'access_token';

  @override
  Future<String?> readToken() async => _preferences.getString(_key);

  @override
  Future<void> saveToken(String token) async =>
      _preferences.setString(_key, token);

  @override
  Future<void> clear() async => _preferences.remove(_key);
}
