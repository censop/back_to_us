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
    );
  }
}