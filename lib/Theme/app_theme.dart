import 'package:flutter/material.dart';

class AppTheme {
  static String poppinsFont = "Poppins";

  static ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 130, 14, 42),
  ),
  brightness: Brightness.light,
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 48,
      fontWeight: FontWeight.w700,
    ),
    displayMedium: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 48,
      fontWeight: FontWeight.w700,
    ),
    titleLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),         
    bodyLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  useMaterial3: true,
);

static ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 130, 14, 42),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 48,
      fontWeight: FontWeight.w700,
    ),
    displayMedium: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 48,
      fontWeight: FontWeight.w700,
    ),
    titleLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),         
    bodyLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  useMaterial3: true,
);
}
     
/* 
static final Color _mainColor = Color.fromARGB(255, 140, 0, 36);

  static final Color _darkBackground = Color.fromARGB(255, 26, 26, 26);
  static final Color _darkScaffold = Color.fromARGB(255, 35, 36, 36);
  static final Color _darkTitleColor = Color.fromARGB(255, 212, 117, 139);
  static final Color _darkOnSecondary = Color.fromARGB(255, 213, 213, 213);
  static final Color _darkSecondary = Color.fromARGB(255, 80, 80, 80);
  static final Color _darkSecondaryVariant = Color.fromARGB(255, 42, 42, 42);

  
  
  static final Color _lightBackground = Color.fromARGB(255, 26, 26, 26);
  static final Color _lightHeaderColor = Color.fromARGB(255, 212, 117, 139);*/