import 'package:back_to_us/Getx/current_user_controller.dart';
import 'package:back_to_us/Screens/NavigationBar/navigation_bar_screen.dart';
import 'package:back_to_us/Widgets/app_theme.dart';
import 'package:back_to_us/Screens/Authentication/ForgotPassword/forgot_password.dart';
import 'package:back_to_us/firebase_options.dart';
import 'package:back_to_us/routes.dart';
import 'package:back_to_us/Screens/Authentication/sign_up_screen.dart';
import 'package:back_to_us/Screens/Authentication/welcome_screen.dart';
import 'package:back_to_us/Screens/NavigationBar/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:back_to_us/Screens/Authentication/log_in_screen.dart';
import 'package:get/get.dart';


/*
  displayLarge => headers
  displayMedium => smaller headers
  titleLarge => section titles
  bodyLarge/bodyMedium => text
  labelLarge => buttons
*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(CurrentUserController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    
    User? currentUser = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      title: 'Back To Us Demo',

      initialRoute: currentUser != null ? Routes.navigationBar : Routes.welcome,

      routes: {
        Routes.home : (context) => HomeScreen(),
        Routes.welcome : (context) => WelcomeScreen(),
        Routes.signUp : (context) => SignUpScreen(),
        Routes.logIn : (context) => LogInScreen(),
        Routes.forgotPassword : (context) => ForgotPassword(),
        Routes.navigationBar : (context) => NavigationBarScreen(),
      },

      theme: AppTheme.myTheme,
    );
  }
}