import 'package:flutter/material.dart';

class MyAppTheme {
  static const String poppinsFont = "Poppins";
  static const String interFont = "Inter";
  static const Color mainColor = Color.fromARGB(255, 116, 13, 13);
  static const Color darkContainerColor = Color.fromARGB(255, 55, 50, 50);
  static const Color lightContainerColor = Color.fromARGB(255, 218, 214, 214);

  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: mainColor,
    brightness: Brightness.light,
  );

  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: mainColor,
    brightness: Brightness.dark,
  );

  static final TextTheme _baseTextTheme = TextTheme().copyWith(
    displayLarge: TextStyle(
      fontSize: 24, 
      fontWeight: FontWeight.w500, 
    ),
    displayMedium: TextStyle(
      fontSize: 22, 
      fontWeight: FontWeight.w500,
    ),
    displaySmall: TextStyle(
      fontSize: 18, 
      fontWeight: FontWeight.normal,
    ),
    headlineLarge: TextStyle(
      fontSize: 24, 
      fontWeight: FontWeight.w500, 
    ),
    headlineMedium: TextStyle(
      fontSize: 18, 
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500, 
    ),
    titleLarge: TextStyle(
      fontSize: 24, 
      fontWeight: FontWeight.w600, 
    ),
    titleMedium: TextStyle(
      fontSize: 18, 
      fontWeight: FontWeight.w600, 
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600, 
    ), 
    bodyLarge: TextStyle(
      fontSize: 16, 
      fontWeight: FontWeight.normal, 
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal, 
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,

    ),
    labelLarge: TextStyle(
      fontSize: 14, 
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      fontSize: 14, 
    ),
    labelSmall: TextStyle(
      fontSize: 14, 
      fontWeight: FontWeight.normal, 
    ),
  );

  static ThemeData lightTheme = ThemeData(
    colorScheme: _lightScheme,
    fontFamily: interFont,
    brightness: Brightness.light,
    textTheme: _baseTextTheme.copyWith(
      bodySmall: _baseTextTheme.bodySmall?.copyWith(
        color: _lightScheme.onSurface.withValues(alpha: 0.5),
      ),
    ),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: _darkScheme,
    fontFamily: interFont,
    textTheme: _baseTextTheme.copyWith(
      bodySmall: _baseTextTheme.bodySmall?.copyWith(
        color: _darkScheme.onSurfaceVariant.withValues(alpha: 0.5),
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