
import 'package:back_to_us/Screens/NavigationBar/capture_screen.dart';
import 'package:back_to_us/Screens/NavigationBar/navigation_bar_screen.dart';
import 'package:back_to_us/Screens/Profile/Friends/added_friends_screen.dart';
import 'package:back_to_us/Screens/Profile/Friends/pending_invites_screen.dart';
import 'package:back_to_us/Screens/Profile/Settings/settings_screen.dart';
import 'package:back_to_us/Screens/Profile/Settings/account_settings_screen.dart';
import 'package:back_to_us/Screens/Profile/Settings/profile_settings_screen.dart';
import 'package:back_to_us/Screens/Profile/Friends/friends_screen.dart';
import 'package:back_to_us/Screens/Profile/profile_screen.dart';
import 'package:back_to_us/Services/camera_service.dart';
import 'package:back_to_us/Services/notifiers.dart';
import 'package:back_to_us/Screens/AlbumRelated/create_album_screen.dart';
import 'package:back_to_us/Theme/app_theme.dart';
import 'package:back_to_us/Screens/Authentication/forgot_password.dart';
import 'package:back_to_us/firebase_options.dart';
import 'package:back_to_us/routes.dart';
import 'package:back_to_us/Screens/Authentication/sign_up_screen.dart';
import 'package:back_to_us/Screens/Authentication/welcome_screen.dart';
import 'package:back_to_us/Screens/NavigationBar/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:back_to_us/Screens/Authentication/log_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
  displayLarge => headers
  displayMedium => smaller headers
  titleLarge => section titles
  bodyLarge/bodyMedium => text
  labelLarge => buttons
*/

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  CameraService.initialize();

  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions()
  );
  darkModeNotifier.value = prefs.getBool('darkMode') ?? true;
  
  runApp(
    const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    
    User? currentUser = FirebaseAuth.instance.currentUser;


    return ValueListenableBuilder(
      valueListenable: darkModeNotifier,
      builder: (context, value, child) {
        return MaterialApp(
          title: 'Back To Us Demo',

          navigatorObservers: [routeObserver], 
          initialRoute: currentUser != null ? Routes.navigationBar : Routes.welcome,
        
          routes: {
            Routes.home : (context) => HomeScreen(),
            Routes.welcome : (context) => WelcomeScreen(),
            Routes.signUp : (context) => SignUpScreen(),
            Routes.logIn : (context) => LogInScreen(),
            Routes.forgotPassword : (context) => ForgotPassword(),
            Routes.navigationBar : (context) => NavigationBarScreen(),
            Routes.profileSettings : (context) => ProfileSettingsScreen(),
            Routes.settings : (context) => SettingsScreen(),
            Routes.profile : (context) => ProfileScreen(),
            Routes.accountSettings : (context) => AccountSettingsScreenn(),
            Routes.createAlbum : (context) => CreateAlbumScreen(),
            Routes.friends : (context) => FriendsScreen(),
            Routes.addedFriends : (context) => AddedFriendsScreen(),
            Routes.pendingInvites : (context) => PendingInvitesScreen(),
            Routes.capture : (context) => CaptureScreen(),
          },
        
          theme: darkModeNotifier.value ? AppTheme.darkTheme : AppTheme.lightTheme,
        );
      }
    );
  }
}