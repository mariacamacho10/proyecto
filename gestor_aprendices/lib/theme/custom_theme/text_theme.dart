import 'package:flutter/material.dart';

class AppTextTheme {
  AppTextTheme._();

  static final TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: Color(0xFF1B1B1B),
    ),

    headlineMedium: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1B1B1B),
    ),

    titleLarge: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFF2E7D32),
    ),

    bodyLarge: const TextStyle(
      fontSize: 15,
      color: Color(0xFF424242),
    ),

    bodyMedium: const TextStyle(
      fontSize: 14,
      color: Color(0xFF616161),
    ),

    labelLarge: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
  );
}