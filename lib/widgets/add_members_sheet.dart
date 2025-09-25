import 'package:flutter/material.dart';

class AddMembersSheet extends StatefulWidget {
  const AddMembersSheet({super.key});

  @override
  State<AddMembersSheet> createState() => _AddMembersSheetState();
}

class _AddMembersSheetState extends State<AddMembersSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: ListView(
        children: [
          Text(
            "Add Members",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          //friends will come here,
          TextButton(
            onPressed: () {}, 
            child: Text("Invite friends")
          )
        ],
      ),
    );
  }
}