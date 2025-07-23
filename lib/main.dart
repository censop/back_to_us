import 'package:back_to_us/firebase_options.dart';
import 'package:back_to_us/screens/Authentication/welcome_screen.dart';
import 'package:back_to_us/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
  displayLarge => headers
  titleLarge => section titles
  bodyLarge/bodyMedium => text
  labelLarge => buttons
*/


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    
    User? currentUser = FirebaseAuth.instance.currentUser;

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
      home: currentUser != null ? HomeScreen() : WelcomeScreen(),
    );
  }
}