import 'package:flutter/material.dart';

class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();

  static final lightTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2E7D32),

      foregroundColor: Colors.white,

      minimumSize: const Size(double.infinity, 56),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}