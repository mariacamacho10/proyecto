import 'package:flutter/material.dart';
import 'package:gestor_aprendices/theme/theme.dart';
import 'package:gestor_aprendices/feature/register/views/segimiento.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}