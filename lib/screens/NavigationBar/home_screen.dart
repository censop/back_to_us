
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
    final height = MediaQuery.of(context).size.height;

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
        stream: FirebaseService.getUserAlbums(), 
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
            padding: EdgeInsets.symmetric(horizontal: width * 0.1, vertical: 40),
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: width * 0.15,
                    mainAxisSpacing: height * 0.01,
                  ), 
                  itemCount: albums.length,
                  itemBuilder: (context, index) {
                    final album = albums[index];
                
                    return AlbumGridItem(
                      coverPath: album.coverPath, 
                      id: album.id, 
                      members: album.members, 
                      mode: album.mode, 
                      name: album.name, 
                      notificationsEnabled: album.notificationsEnabled, 
                      openAt: album.openAt
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
      
      
      
      /*Padding(
        padding: const EdgeInsets.all(8),
        child: ValueListenableBuilder(
          valueListenable: albumIdsNotifier,
          builder: (context, value, child) {
            return Center(
              child: value == null || value.isEmpty ? 
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
                  /*AlbumGridItem(
                    coverPath: ,
                  ),*/
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    iconSize: 50,
                    onPressed: _clickCreateIcon,
                  ),
                ]
              ),
            );
          }
        )
      ),*/
    );
  }

  void _clickCreateIcon() {
    Navigator.of(context).pushNamed(
      Routes.createAlbum
    );
  }
}