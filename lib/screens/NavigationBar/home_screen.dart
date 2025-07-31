
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  /*List<AlbumListTile> dummyAlbums = [
    AlbumListTile(color: Colors.orange, title: "Album 1"),
    AlbumListTile(color: Colors.deepPurple, title: "Album 2"),

  ];*/

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
        toolbarHeight: 100,
        titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          "Back\nTo\nUs",
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
            Text(
              "Welcome ${FirebaseService.currentUser?.username ?? ""}!",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            //...dummyAlbums,
          ],
        ),
      ),
    );
  }
}