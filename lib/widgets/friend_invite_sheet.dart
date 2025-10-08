
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FriendInviteSheet extends StatefulWidget {
  const FriendInviteSheet({
    super.key,
    required this.rootContext,
  });

  final BuildContext rootContext;

  @override
  State<FriendInviteSheet> createState() => _FriendInviteSheetState();
}

class _FriendInviteSheetState extends State<FriendInviteSheet> {
  String? inviteLink;

  TextEditingController _inviteIdController = TextEditingController();

  @override
  void dispose() {
    _inviteIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "Add a Friend",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height:5),
          Text("Send you friend invite ID to whoever you want to add! \n This is you friend invite ID: "),
          Text(FirebaseService.currentUser!.friendInviteId),
          IconButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: FirebaseService.currentUser!.friendInviteId));
            }, 
            icon: Icon(Icons.copy)
          ),
          SizedBox(height:5),
          Text("OR"),
          Text("Send a friend request by entering your friend's friend invite ID: "),
          SizedBox(height: 5),
          CustomTextFormField(
            controller: _inviteIdController, 
            title: "Enter Friend Invite ID"
          ),
          ElevatedButton(
            onPressed: () async {
              bool requestSent = await FirebaseService.sendFriendInvite(_inviteIdController.text);
              print(requestSent);
            }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary
            ),
            child: Text(
              "Send Request",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              )
            )
          ),
        ],
      ),
    );
  }
}