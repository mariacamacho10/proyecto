import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_aprendices/core/bloc/app_bloc.dart';
import 'package:gestor_aprendices/feature/register/views/register_anotations_view.dart';
import 'package:gestor_aprendices/feature/students/views/students_view.dart';
import 'package:gestor_aprendices/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(),
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const StudentsView(),
      ),
    );
  }
}
