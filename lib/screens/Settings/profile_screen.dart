import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:back_to_us/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  void _logOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.welcome, 
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          "Profile",
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
            Center(
              child: Stack(
                children: [
                  CustomProfilePictureDisplayer(
                    imageUrl: FirebaseService.currentUser?.profilePic, 
                    radius: 50,
                  ),
                  Positioned(
                    top: -8,
                    right: -10,
                    child: IconButton(
                      onPressed: () {}, 
                      icon: Icon(Icons.edit),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ]
              ),
            ),
            Divider(
              height: 50,
              thickness: 5,
            ),
            Text(
              "Username: ${FirebaseService.currentUser?.username}",
              style: Theme.of(context).textTheme.bodyLarge,
            ), 
            //...dummyAlbums,
          ],
        ),
      ),
    );
  }
}