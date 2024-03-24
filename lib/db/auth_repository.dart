import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/model/login_response.dart';
import 'package:story_app/model/user.dart';
import 'package:http/http.dart' as http;

class AuthRepository extends ChangeNotifier {
  final String stateKey = "state";
  final String userKey = "user";
  String token = "";
  String userId = "";
  String name = "";

  // login
  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.getBool(stateKey) ?? false;
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setBool(stateKey, false);
  }

  // register
  Future<bool> saveUser(User user) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(userKey, user.toJson());
  }

  // Future<bool> login() async {
  //   final preferences = await SharedPreferences.getInstance();
  //   await Future.delayed(const Duration(seconds: 2));
  //   return preferences.setBool(stateKey, true);
  // }

  Future<bool> deleteUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(userKey, "");
  }

  Future<User?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    final json = preferences.getString(userKey) ?? "";
    User? user;
    try {
      user = User.fromJson(json);
    } catch (exception) {
      user = null;
    }
    return user;
  }

  Future<bool> register(User user) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final response = await http.post(
        Uri.parse('https://story-api.dicoding.dev/v1/register'),
        body: jsonEncode({
          'name': user.name,
          'email': user.email,
          'password': user.password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        // print("Register fail ${response.statusCode}");
        return false;
      }
    } catch (error) {
      // print('Error registering user: $error');
      return false;
    }
  }

  Future<LoginResponse> login(User user) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final response = await http.post(
        Uri.parse('https://story-api.dicoding.dev/v1/login'),
        body: jsonEncode({
          'email': user.email,
          'password': user.password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception("failed login");
      }
    } catch (error) {
      throw Exception(error);
    }
  }
}
