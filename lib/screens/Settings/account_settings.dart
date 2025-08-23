
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/change_password_sheet.dart';
import 'package:back_to_us/Widgets/custom_settings_tiles.dart';
import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          "Account Settings",
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: ListView(
        children: [
          CustomSettingsTiles(
            leading: Text(
              "E-mail: ",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            mainWidget: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: FirebaseService.currentUser?.email,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomSettingsTiles(
            title: "Change Password",
            onPressed: changePassword,
          ),
          CustomSettingsTiles(
            title: "Membership Plan",
            onPressed: () {},
          ),
          CustomSettingsTiles(
            title: "Log out",
            trailing: Icon(Icons.logout),
            onPressed: () {
              FirebaseService.logOut(context);
            }
          ),
          CustomSettingsTiles(
            title: "Delete account",
            trailing: Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  //add logic
  void changePassword() {
    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return ChangePasswordSheet();
      }
    );
  }
}