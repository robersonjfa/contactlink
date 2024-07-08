import 'package:contactlink/screens/about_screen.dart';
import 'package:contactlink/screens/photo_capture_screen.dart';
import 'package:contactlink/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String about = '/about';
  static const String photoCapture = '/photoCapture';

  static Map<String, WidgetBuilder> define() {
    return {
      splash: (context) => SplashScreen(),
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
      about: (context) => const AboutScreen(),
      photoCapture: (context) => const PhotoCaptureScreen(),
    };
  }
}
