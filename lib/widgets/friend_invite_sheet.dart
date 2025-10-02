import 'package:flutter/material.dart';

class FriendInviteSheet extends StatefulWidget {
  const FriendInviteSheet({super.key});

  @override
  State<FriendInviteSheet> createState() => _FriendInviteSheetState();
}

class _FriendInviteSheetState extends State<FriendInviteSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            "Send Friend Invite",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}