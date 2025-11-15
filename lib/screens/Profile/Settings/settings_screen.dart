import 'package:back_to_us/Services/notifiers.dart';
import 'package:back_to_us/Widgets/custom_settings_tiles.dart';
import 'package:back_to_us/routes.dart';
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
        title: Text(
          "Settings",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView(
          children: [
            CustomSettingsTiles(
              title: "Profile Settings",
              leading:Icon(Icons.account_circle_outlined),
              onPressed:() {
                Navigator.of(context).pushNamed(Routes.profileSettings);
              },
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ),
            CustomSettingsTiles(
              title: "Account Settings",
              leading:Icon(Icons.lock_outline),
              onPressed:() {
                Navigator.of(context).pushNamed(
                  Routes.accountSettings
                );
              },
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ),
            CustomSettingsTiles(
              title: "Language Settings",
              leading:Icon(Icons.language),
              onPressed:() {
                //to be filled
              },
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: darkModeNotifier,
              builder: (context, isDarkMode, child) {
                return CustomSettingsTiles(
                  title: isDarkMode ? "Dark Mode" : "Light Mode",
                  leading: isDarkMode ? Icon(Icons.dark_mode) : Icon(Icons.light_mode),
                  trailing: Switch(
                    activeColor: const Color.fromARGB(255, 130, 14, 42),
                    value: isDarkMode,
                    onChanged: (value) async {
                      darkModeNotifier.value = value;
                      final prefs = await SharedPreferencesWithCache.create(
                        cacheOptions: const SharedPreferencesWithCacheOptions()
                      );
                      await prefs.setBool('darkMode', darkModeNotifier.value);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
