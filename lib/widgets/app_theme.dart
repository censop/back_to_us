import 'package:flutter/material.dart';

class AppTheme {
  static String poppinsFont = "Poppins";


  static ThemeData myTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 130, 14, 42),
  ).copyWith(
    background: Colors.white,
    primary: const Color.fromARGB(255, 130, 14, 42),
  ),
  scaffoldBackgroundColor: Colors.white,
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
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    ),
    bodyMedium: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    ),
    labelLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: const Color.fromARGB(255, 130, 14, 42),
    ),
  ),
  useMaterial3: true,
);
}

