import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:flutter/material.dart';

class AddedFriendsScreen extends StatefulWidget {
  const AddedFriendsScreen({super.key});

  @override
  State<AddedFriendsScreen> createState() => _AddedFriendsScreenState();
}

class _AddedFriendsScreenState extends State<AddedFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Added Friends"),
        centerTitle: true,
      ),

      body: StreamBuilder<List<AppUser>>(
        stream: FirebaseService.friendsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "You haven't added any friends yet.", 
                style: Theme.of(context).textTheme.titleMedium,
              )
            );
          }

          final friends = snapshot.data!;

           return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];

              return ListTile(
                leading: CustomProfilePictureDisplayer(
                  radius: 30,
                  profileUrl: friend.profilePic ?? "",
                ),
                title: Text(friend.username),
              );    
            }
          );
        },
      )
    );
  }
}