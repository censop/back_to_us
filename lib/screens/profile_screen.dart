import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:back_to_us/routes.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
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
      ),
    );
  }
}