import 'package:flutter/material.dart';

class AppTheme {
  static String poppinsFont = "Poppins";

  static ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 130, 14, 42),
  ).copyWith(
    surface: const Color.fromARGB(255, 241, 241, 241),
    primary: const Color.fromARGB(255, 130, 14, 42),
    secondary: const Color.fromARGB(255, 241, 241, 241),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 255, 249, 249),
  brightness: Brightness.light,
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 48,
      fontWeight: FontWeight.w700,
      color: const Color.fromARGB(255, 130, 14, 42),
    ),
    displayMedium: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 48,
      fontWeight: FontWeight.w700,
      color: const Color.fromARGB(255, 130, 14, 42),
    ),
    titleLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    titleMedium: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),         
    bodyLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    ),
    bodyMedium: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    ),
    labelLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  ),
  useMaterial3: true,
);

static ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 249, 244, 246),
  ).copyWith(
    surface: const Color.fromARGB(255, 10, 10, 10),
    primary: const Color.fromARGB(255, 249, 244, 246),
    secondary: const Color.fromARGB(255, 130, 14, 42),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 32, 30, 31),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 48,
      fontWeight: FontWeight.w700,
      color: const Color.fromARGB(255, 179, 55, 84),
    ),
    displayMedium: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 48,
      fontWeight: FontWeight.w700,
      color: const Color.fromARGB(255, 130, 14, 42),
    ),
    titleLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: const Color.fromARGB(221, 169, 164, 164),
    ),
    titleMedium: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: const Color.fromARGB(221, 169, 164, 164),
    ),         
    bodyLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: const Color.fromARGB(221, 169, 164, 164),
    ),
    bodyMedium: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: const Color.fromARGB(221, 169, 164, 164),
    ),
    labelLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: const Color.fromARGB(255, 32, 30, 31),
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