import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/model/login_response.dart';

class LoginPreferences {
  final SharedPreferences sharedPreferences;

  LoginPreferences(this.sharedPreferences);

  static const prefrencesKey = 'auth';
  static const loginInfoKey = '$prefrencesKey.loginInfo';

  Future<bool> saveLoginInfo(LoginResponse login) {
    final jsonStr = login.toJson();
    return sharedPreferences.setString(loginInfoKey, jsonStr.toString());
  }
}
