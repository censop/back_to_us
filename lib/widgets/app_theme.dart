import 'package:flutter/material.dart';

class AppTheme {
  static String poppinsFont = "Poppins";


  static ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 130, 14, 42),
  ).copyWith(
    surface: const Color.fromARGB(255, 241, 241, 241),
    primary: const Color.fromARGB(255, 130, 14, 42),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 241, 241, 241),
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
    surface: const Color.fromARGB(255, 32, 30, 31),
    primary: const Color.fromARGB(255, 249, 244, 246),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 32, 30, 31),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 48,
      fontWeight: FontWeight.w700,
      color: const Color.fromARGB(255, 249, 244, 246),
    ),
    displayMedium: TextStyle(
      fontFamily: poppinsFont,
      fontSize: 48,
      fontWeight: FontWeight.w700,
      color: const Color.fromARGB(255, 249, 244, 246),
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
     
