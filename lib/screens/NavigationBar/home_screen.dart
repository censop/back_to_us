
import 'package:back_to_us/Models/album.dart';
import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Theme/my_app_theme.dart';
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
  late Stream<List<Album>> _albumStream;

  @override
  void initState() {
    super.initState();

    _albumStream = FirebaseService.albumStream();
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    final padding = width * 0.05; 

    return StreamBuilder(
      stream: _albumStream, 
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

        final availableAlbums = albums.where((album) => album.isOpen).toList();
        final unavailableAlbums = albums.where((album) => !album.isOpen).toList();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [   
                Row(
                  children: [
                    Text(
                      FirebaseService.currentUser?.username != null 
                      ? "${FirebaseService.currentUser!.username}'s Vaults"
                      : "Your Vaults",
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          Routes.createAlbum
                        );
                      }, 
                      child: Icon(Icons.add_circle_outline) 
                    )
                  ],
                ),
                Divider(
                  height: 16,
                  endIndent: 8,
                  indent: 8,
                ),
                _buildSectionTitle("Locked"),
                SizedBox(
                  height: 8,
                ),
                _buildGrid(unavailableAlbums, padding),
                SizedBox(
                  height: 16,
                ),
                _buildSectionTitle("Unlocked"),
                SizedBox(
                  height: 8,
                ),
                _buildGrid(availableAlbums, padding),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  void _clickCreateIcon() {
    Navigator.of(context).pushNamed(
      Routes.createAlbum
    );
  }

  Widget _buildGrid(List<Album> items, double padding) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.30,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 5/3,
          mainAxisSpacing: padding,
        ), 
        itemCount: items.length,
        itemBuilder: (context, index) {
          final album = items[index];
      
          return AlbumGridItem(
            album: album
          );
        }
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium
        ),
        IconButton(
          onPressed: () {}, 
          icon: Icon(
            Icons.arrow_forward_ios,
            size: 15,
          )
        )
      ],
    );
  } 
}
