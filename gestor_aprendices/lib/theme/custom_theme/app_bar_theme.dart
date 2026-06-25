import 'package:flutter/material.dart';

class AppAppBarTheme {
  AppAppBarTheme._();

  static const AppBarTheme lightTheme = AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.transparent,
    foregroundColor: Color(0xFF1B1B1B),
    elevation: 0,
    scrolledUnderElevation: 0,
    titleTextStyle: TextStyle(
      color: Color(0xFF1B1B1B),
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  );
}