import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/custom_snackbar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "Send Friend Invite",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height:5),
          FutureBuilder<String?>(
            future: FirebaseService.createInviteLink(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                inviteLink = snapshot.data;
                return Text(snapshot.data ?? 'No invite link generated');
              } else {
                return const Text('No invite link generated');
              }
            },
          ),
          SizedBox(height: 5,),
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: inviteLink ?? ""));
              
              Navigator.of(context).pop();

              ScaffoldMessenger.of(
                widget.rootContext
                ).showSnackBar(
                customSnackbar(
                  content: Text("Friend invite link has been copied to clipboard."), 
                  backgroundColor: Theme.of(context).colorScheme.primary
                )
              );
            },
          )
        ],
      ),
    );
  }
}