import 'package:flutter/material.dart';

class MyAppTheme {
  static const String poppinsFont = "Poppins";
  static const String interFont = "Inter";
  static const Color mainColor = Color.fromARGB(255, 130, 14, 42);
  static const Color darkContainerColor = const Color.fromARGB(255, 75, 69, 69);
  static const Color lightContainerColor = const Color.fromARGB(255, 206, 203, 203);

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
      //color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)
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
    colorScheme: ColorScheme.fromSeed(
      seedColor: mainColor,
    ).copyWith(
      surfaceContainer: const Color.fromARGB(255, 219, 216, 216)
    ),
    fontFamily: interFont,
    brightness: Brightness.light,
    textTheme: _baseTextTheme,
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: mainColor,
    ).copyWith(
      surfaceContainer: const Color.fromARGB(255, 44, 40, 40)
    ),
    fontFamily: interFont,
    textTheme: _baseTextTheme,
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