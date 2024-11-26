import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool getThemeData() => _isDarkMode;

  void updateTheme({required bool value}) {
    _isDarkMode = value;
    notifyListeners();
  }
}
