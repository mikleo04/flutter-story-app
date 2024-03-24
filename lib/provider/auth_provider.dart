import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/db/auth_repository.dart';
import 'package:story_app/model/login_response.dart';
import 'package:story_app/model/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider(this.authRepository);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;

  Future<LoginResponse> login(User user) async {
    isLoadingLogin = true;
    notifyListeners();

    // final userState = await authRepository.getUser();
    // if (user == userState) {
    final userState = await authRepository.login(user);
    // }
    // isLoggedIn = await authRepository.isLoggedIn();

    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = userState.loginResult.token;
    print('that is the token :  $token');
    await pref.setString('token', token);

    isLoadingLogin = false;
    notifyListeners();

    return userState;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    SharedPreferences pref = await SharedPreferences.getInstance();
    bool status = await pref.remove('token');

    isLoadingLogout = false;
    notifyListeners();

    return status;
  }

  Future<bool> saveUser(User user) async {
    isLoadingRegister = true;
    notifyListeners();

    final userState = await authRepository.saveUser(user);

    isLoadingRegister = false;
    notifyListeners();
    return userState;
  }

  Future<bool> registerUser(User user) async {
    isLoadingRegister = true;
    notifyListeners();

    final userState = await authRepository.register(user);

    isLoadingRegister = false;
    notifyListeners();
    return userState;
  }
}
