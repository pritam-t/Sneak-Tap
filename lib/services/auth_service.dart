import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final SharedPreferences _prefs;
  static const String _authKey = 'is_logged_in';

  AuthService(this._prefs);

  bool get isLoggedIn => _prefs.getBool(_authKey) ?? false;

  Future<bool> login(String username, String password) async {
    // Dummy authentication logic from spec
    if (username == 'pritam123' && password == '12345678') {
      await _prefs.setBool(_authKey, true);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _prefs.setBool(_authKey, false);
  }
}
