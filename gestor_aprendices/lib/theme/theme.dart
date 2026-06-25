import 'package:flutter/material.dart';
import 'package:gestor_aprendices/theme/custom_theme/app_bar_theme.dart';
import 'package:gestor_aprendices/theme/custom_theme/elevated_button_theme.dart';
import 'package:gestor_aprendices/theme/custom_theme/outline_button_theme.dart';
import 'package:gestor_aprendices/theme/custom_theme/text_field_theme.dart';
import 'package:gestor_aprendices/theme/custom_theme/text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    fontFamily: 'Inter',

    primaryColor: const Color(0xFF2E7D32),

    scaffoldBackgroundColor: const Color(0xFFF4F7F5),

    textTheme: AppTextTheme.lightTextTheme,

    elevatedButtonTheme: AppElevatedButtonTheme.lightTheme,

    outlinedButtonTheme: AppOutlinedButtonTheme.lightTheme,

    inputDecorationTheme: AppTextFieldTheme.lightTheme,

    appBarTheme: AppAppBarTheme.lightTheme,

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF2E7D32),
      foregroundColor: Colors.white,
    ),
  );
}