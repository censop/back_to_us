import 'package:back_to_us/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/*
  displayLarge => headers
  titleLarge => section titles
  bodyLarge/bodyMedium => texts
  labelLarge => buttons
*/


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Back To Us Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 130, 14, 42),
        ).copyWith(
          background: Colors.white,
          primary: const Color.fromARGB(255, 130, 14, 42),
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          displayLarge: GoogleFonts.poppins(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 130, 14, 42),
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black87,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.black87,
          ),
          labelLarge: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 130, 14, 42),
          ),
        ),
  useMaterial3: true,
),
      home: SignUpScreen(),
    );
  }
}