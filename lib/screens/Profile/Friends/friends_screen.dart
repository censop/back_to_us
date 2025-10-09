import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/custom_settings_tiles.dart';
import 'package:back_to_us/Widgets/friend_invite_sheet.dart';
import 'package:back_to_us/routes.dart';
import 'package:flutter/material.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CustomSettingsTiles(
            title: "Added Friends",
            leading: Icon(Icons.emoji_people),
            trailing: Text(FirebaseService.currentUser!.friends.length.toString()),
            onPressed: () {
              Navigator.of(context).pushNamed(
                Routes.addedFriends
              );
            },
          ),
          //logic will be added for the invite amount
          CustomSettingsTiles(
            title: "Pending Invites",
            leading: Icon(Icons.mail),
            trailing: StreamBuilder(
              stream: FirebaseService.pendingInvitesStream(),
              builder: (context, asyncSnapshot) {
                final int count = asyncSnapshot.data?.length ?? 0;
                return Text(count.toString());
              }
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(
                Routes.pendingInvites
              );
            },
          ),
          CustomSettingsTiles(
            title: "Add a Friend",
            leading: Icon(Icons.add_reaction),
            onPressed: () {
              BuildContext rootContext = context;

              showModalBottomSheet(
                context: rootContext, 
                builder: (context) {
                  return FriendInviteSheet(rootContext: rootContext,);
                }
              );
            },
          )
        ],
      )
    );
  }

}