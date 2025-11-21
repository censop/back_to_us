import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:back_to_us/Widgets/custom_settings_tiles.dart';
import 'package:back_to_us/routes.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile"
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Row(
            children: [
              Hero(
                tag: "profilePic",
                child: CustomProfilePictureDisplayer(
                 radius: 50,
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello,",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary
                    ),
                  ),
                  Text(
                    "${FirebaseService.currentUser?.username ?? "Loading.."}!",
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          CustomSettingsTiles(
            title: "Settings",
            leading: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(
                Routes.settings,
              );
            },
          ),
          CustomSettingsTiles(
            title: "Friends",
            leading: Icon(Icons.people),
            onPressed: () {
              Navigator.of(context).pushNamed(
                Routes.friends,
              );
            },
          ),
          CustomSettingsTiles(
            title: "Notifications",
            leading: Icon(Icons.notifications),
            onPressed: () {
              //to be filled
            },
          ),
        ],
      )
    );
  }
}