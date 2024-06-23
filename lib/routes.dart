import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';

  static Map<String, WidgetBuilder> define() {
    return {
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
    };
  }
}
