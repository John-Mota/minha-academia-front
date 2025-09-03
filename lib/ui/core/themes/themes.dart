import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';

// O tema escuro
final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: darkBackgroundColor,
  primaryColor: primaryColor,
  colorScheme: const ColorScheme.dark(
    primary: primaryColor,
    onPrimary: Colors.white,
    secondary: Color(0xFFEE5B2A),
    onSecondary: Colors.white,
    surface: darkBackgroundColor,
    onSurface: darkForegroundColor,
    error: destructiveColor,
    onError: Colors.white,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: 'Poppins'),
    bodyLarge: TextStyle(fontFamily: 'Inter'),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: darkForegroundColor),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: darkBackgroundColor,
    labelStyle: TextStyle(color: darkForegroundColor),
    hintStyle: TextStyle(color: darkForegroundColor.withOpacity(0.6)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(color: primaryColor, width: 0.8),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(color: primaryColor, width: 0.8),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(color: primaryColor, width: 0.8),
    ),
  ),
);

// O tema claro
final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: lightBackgroundColor,
  primaryColor: primaryColor,
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    onPrimary: Colors.white,
    secondary: secondaryColor,
    onSecondary: Colors.white,
    surface: lightBackgroundColor,
    onSurface: lightForegroundColor,
    error: destructiveColor,
    onError: Colors.white,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: 'Poppins'),
    bodyLarge: TextStyle(fontFamily: 'Inter'),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: lightForegroundColor),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: lightBackgroundColor,
    labelStyle: TextStyle(color: lightForegroundColor),
    hintStyle: TextStyle(color: lightForegroundColor.withOpacity(0.6)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(color: primaryColor, width: 0.8),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(color: primaryColor, width: 0.8),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(color: primaryColor, width: 0.8),
    ),
  ),
);
