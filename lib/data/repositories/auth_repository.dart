import 'package:flutter/material.dart';

class AuthRepository extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLogged => _isLoggedIn;

  void loginSuccess() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
