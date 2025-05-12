import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _username = '';
  String _error = '';
  bool _isLoading = false;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  String get error => _error;
  bool get isLoading => _isLoading;

  // Login method (mock authentication)
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    // Simulate API delay
    await Future.delayed(Duration(seconds: 2));

    // Mock validation (in a real app, this would call an authentication API)
    if (username.isNotEmpty && password.length >= 6) {
      _isLoggedIn = true;
      _username = username;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Invalid username or password. Password must be at least 6 characters.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout method
  void logout() {
    _isLoggedIn = false;
    _username = '';
    notifyListeners();
  }
}