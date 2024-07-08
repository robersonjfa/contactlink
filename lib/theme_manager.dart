import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'themes.dart';

class ThemeManager with ChangeNotifier {
  static const String _themeKey = 'theme_key';
  bool _isGreenTheme = true;

  ThemeData get themeData => _isGreenTheme ? greenTheme : blueTheme;

  ThemeManager() {
    _loadTheme();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isGreenTheme = prefs.getBool(_themeKey) ?? true;
    notifyListeners();
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isGreenTheme = !_isGreenTheme;
    prefs.setBool(_themeKey, _isGreenTheme);
    notifyListeners();
  }
}
