
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Services/notifiers.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:back_to_us/Widgets/custom_settings_tiles.dart';
import 'package:back_to_us/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          "Settings",
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            onPressed: _logOut,
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),

      //PLACEHOLDER
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CustomProfilePictureDisplayer(
                    radius: 50,
                  ),
                  SizedBox(width: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello,"),
                      Text(
                        "${FirebaseService.currentUser!.username}!",
                        style: Theme.of(context).textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                  
                ],
              ),
            ),
            Divider(
              height: 50,
              thickness: 7,
              color: Theme.of(context).colorScheme.primary,
            ),
             Text(
              "About your account",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 14
              ),
            ),
            CustomSettingsTiles(
              title: "Friends",
              //friends ekle firebase
              trailing:Text(
                "0",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Color.fromARGB(255, 165, 165, 165),
                ),
              ),
              onPressed:() {
                //fill this
              },
            ),
            CustomSettingsTiles(
              title: "Albums",
              //friends ekle firebase
              trailing:Text(
                FirebaseService.currentUser!.albumIds != null ? FirebaseService.currentUser!.albumIds!.length.toString() : "0",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Color.fromARGB(255, 165, 165, 165),
                ),
              ),
              onPressed:() {
                //fill this
              },
            ),
            Divider(
              height: 50,
              thickness: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              "About your profile",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 14
              ),
            ),
            CustomSettingsTiles(
              title: "Profile Settings",
              leading:Icon(Icons.account_circle),
              onPressed:() {
                Navigator.of(context).pushNamed(Routes.profileSettings);
              },
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ),
            Divider(
              height: 50,
              thickness: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              "Display",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 14
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: darkModeNotifier,
              builder: (context, isDarkMode, child) {
                return SwitchListTile(
                  activeColor: const Color.fromARGB(255, 130, 14, 42),
                  title: Text(isDarkMode ? "Dark Mode" : "Light Mode"),
                  value: isDarkMode,
                  onChanged: (value) async {
                    darkModeNotifier.value = value;
                    final prefs = await SharedPreferencesWithCache.create(
                      cacheOptions: const SharedPreferencesWithCacheOptions()
                    );
                    await prefs.setBool('darkMode', darkModeNotifier.value);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _logOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.welcome, 
      (Route<dynamic> route) => false,
    );
  }

}