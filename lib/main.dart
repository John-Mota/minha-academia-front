import 'package:flutter/material.dart';
import 'package:minha_academia_front/theme/app_colors.dart';
import 'package:minha_academia_front/theme/app_theme.dart';
import 'package:minha_academia_front/pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Academia',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/login',
      routes: {'/login': (context) => const LoginScreen()},
    );
  }
}
