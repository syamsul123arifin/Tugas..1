import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../services/api_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  User? _user;
  bool _isAuthenticated = false;

  String? get token => _token;
  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String email, String password) async {
    final response = await ApiService().login(email, password);
    _token = response['token'];
    _user = User.fromJson(response['user']);
    _isAuthenticated = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    await prefs.setString('user', _user!.toJson().toString());
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    _isAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');
    final storedUser = prefs.getString('user');
    if (storedToken != null && storedUser != null) {
      _token = storedToken;
      _user = User.fromJson(json.decode(storedUser));
      _isAuthenticated = true;
      notifyListeners();
    }
  }
}