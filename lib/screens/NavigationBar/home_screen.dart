import 'package:back_to_us/Getx/current_user_controller.dart';
import 'package:back_to_us/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //c is the controller
  CurrentUserController c = Get.find();

/*
  AppUser? currentUser;

  Future<void> getAppUser() async {
    try {
       DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .get();
    setState(() {
      currentUser = AppUser.fromJson(doc.data() as Map<String, dynamic>);
    });
    } catch (e) {
      print(e);
    }
  }*/

  @override
  void initState() {
    super.initState();
    c.onInit();
  }

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
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
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
              "Welcome ${c.currentUser?.username ?? ""}!",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            //...dummyAlbums,
          ],
        ),
      ),
    );
  }
}