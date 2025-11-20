
import 'package:back_to_us/Models/album.dart';
import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Theme/my_app_theme.dart';
import 'package:back_to_us/Widgets/album_grid_item.dart';
import 'package:back_to_us/Widgets/custom_primary_elevated_button.dart';
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
                    _clickCreateButton();
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
                    CustomPrimaryElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          Routes.createAlbum
                        );
                      }, 
                      child: Text("Create vault") 
                    )
                  ],
                ),
                Divider(
                  thickness: 1,
                  height: 64,
                  endIndent: 8,
                  color: Theme.of(context).colorScheme.onSurface,
                  indent: 8,
                  radius: BorderRadius.circular(32),
                ),
                _buildSectionTitle("Locked"),
                SizedBox(
                  height: 8,
                ),
                _buildGrid(unavailableAlbums, padding, false),
                SizedBox(
                  height: 16,
                ),
                _buildSectionTitle("Unlocked"),
                SizedBox(
                  height: 8,
                ),
                _buildGrid(availableAlbums, padding, true),
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

  void _clickCreateButton() {
    Navigator.of(context).pushNamed(
      Routes.createAlbum
    );
  }

  Widget _buildGrid(List<Album> items, double padding, bool isAvailable) {
    final displayItems = items.take(5).toList();
    
    final shouldShowViewAll = items.length > 5;
    
    final itemCount = displayItems.length + (shouldShowViewAll ? 1 : 0);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.30,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 5 / 3,
          mainAxisSpacing: padding,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (shouldShowViewAll && index == displayItems.length) {
            return _buildViewAllItem(items, isAvailable);
          }
          
          final album = displayItems[index];

          return AlbumGridItem(
            album: album,
          );
        },
      ),
    );
  }

  Widget _buildViewAllItem(List<Album> allAlbums, bool isAvailable) {
    return GestureDetector(
      onTap: () => _navigateToViewAll(allAlbums, isAvailable),
      child: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.arrow_forward,
                  size: 50,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: 8.0),
                Text(
                  'View All (${allAlbums.length})',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _navigateToViewAll(List<Album> albums, bool isAvailable) {
    print("successful");
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
