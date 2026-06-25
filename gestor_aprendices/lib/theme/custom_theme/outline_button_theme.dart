import 'package:flutter/material.dart';

class AppOutlinedButtonTheme {
  AppOutlinedButtonTheme._();

  static final OutlinedButtonThemeData lightTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF2E7D32),

          side: const BorderSide(
            color: Color(0xFF2E7D32),
            width: 1.5,
          ),

          minimumSize: const Size(double.infinity, 56),

          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),

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