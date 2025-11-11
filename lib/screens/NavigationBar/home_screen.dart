
import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/album_grid_item.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:back_to_us/routes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  AppUser? user = FirebaseService.currentUser;

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    final padding = width * 0.05; 

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

      body: StreamBuilder(
        stream: FirebaseService.albumStream(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasError) {
            return Text("There has been an error, try again.");
          }

          final albums = snapshot.data ?? [];

          albums.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (albums.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 40),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {}, 
                      icon: Icon(Icons.list)
                    ),
                    IconButton(
                      onPressed: () {}, 
                      icon: Icon(Icons.grid_view)
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {}, 
                      icon: Icon(Icons.filter_alt)
                    ),
                  ],
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: padding,
                    mainAxisSpacing: padding,
                  ), 
                  itemCount: albums.length,
                  itemBuilder: (context, index) {
                    final album = albums[index];
                
                    return AlbumGridItem(
                      album: album
                    );
                  }
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  iconSize: 50,
                  onPressed: _clickCreateIcon,
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  void _clickCreateIcon() {
    Navigator.of(context).pushNamed(
      Routes.createAlbum
    );
  }
}