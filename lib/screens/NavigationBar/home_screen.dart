
import 'package:back_to_us/Services/notifiers.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:back_to_us/routes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
          CustomProfilePictureDisplayer(
            radius: 30,
            onPressed: () {
              Navigator.of(context).pushNamed(
                Routes.profile,
              );
            },
          ),
          SizedBox(width: 20,)
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ValueListenableBuilder(
          valueListenable: albumIdsNotifier,
          builder: (context, value, child) {
            return Center(
              child: value == null ? 
              Column(
                mainAxisAlignment: value == null ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  Text(
                    "Create your first album", 
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    iconSize: 50,
                    onPressed: () {
                      _clickCreateIcon();
                    },
                  ),
                ]
              ) :
              Column(
                children: [
                  Text("you have an album"),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    iconSize: 50,
                    onPressed: () {},
                  ),
                ]
              ),
            );
          }
        )
      ),
    );
  }

  void _clickCreateIcon() {
    Navigator.of(context).pushNamed(
      Routes.createAlbum
    );
  }
}