import 'package:back_to_us/Widgets/friend_invite_sheet.dart';
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
      body: Center(
        child: TextButton(
          onPressed: () {
            showModalBottomSheet(
              context: context, 
              builder: (context) {
                return FriendInviteSheet();
              }
            );
          }, 
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent, 
            overlayColor: Colors.transparent,
          ),
          child: Text(
            "Send an invite link.",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: const Color.fromARGB(255, 130, 14, 42),
            ),
          ),
        ),
      )
    );
  }

}