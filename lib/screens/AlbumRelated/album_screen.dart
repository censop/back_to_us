import 'package:back_to_us/Models/album.dart';
import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Services/user_cache_service.dart';
import 'package:back_to_us/Theme/my_app_theme.dart';
import 'package:back_to_us/Widgets/album_cover.dart';
import 'package:back_to_us/Widgets/album_gallery_slivers.dart'; 
import 'package:back_to_us/Widgets/custom_primary_elevated_button.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:back_to_us/Widgets/stacked_member_display.dart';
import 'package:back_to_us/routes.dart';
import 'package:flutter/material.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({
    super.key,
    required this.album
  });

  final Album album;

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Back to Us",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: MyAppTheme.mainColor,
          )
        ),
        centerTitle: true,
        actions: [
          CustomProfilePictureDisplayer(
            radius: 24,
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.profile);
            },
          ),
          const SizedBox(width: 16,)
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: AspectRatio(
                        aspectRatio: 5/6,
                        child: Hero(
                          tag: widget.album.id,
                          child: AlbumCover(album: widget.album)
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.album.name,
                      style: Theme.of(context).textTheme.titleLarge
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder(
                      future: _getCreatorName(widget.album.owner),
                      builder: (context, snapshot) {
                        return Text(
                          "Created by ${snapshot.data ?? 'Unknown'}",
                          style: Theme.of(context).textTheme.bodySmall,
                        );
                      }
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder<List<AppUser>>(
                      future: UserCacheService.getUsers(widget.album.members),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const SizedBox();
                        }
                        final displayUsers = snapshot.data!; 
                        return StackedMemberDisplay(displayUsers: displayUsers, userLength: displayUsers.length);
                      }
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            widget.album.isOpen
                ? _buildUnlockedSliver()
                : _buildLockedSliver(),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Future<String> _getCreatorName(String uid) async {
    AppUser creator = await FirebaseService.getAppUserByUid(uid);
    return creator.username;
  }

  Widget _buildLockedSliver() {
    return SliverFillRemaining(
      hasScrollBody: false, 
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surfaceContainer
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_clock, 
              size: 150,
            ),
            const SizedBox(height: 8),
            Text(
              "This vault is locked.",
              style: Theme.of(context).textTheme.titleLarge
            ),
            const SizedBox(height: 8),
            Text(
              "It will unlock on ${widget.album.readableOpenAt}.",
              style: Theme.of(context).textTheme.bodySmall
            ),
            const SizedBox(height: 16),
            CustomPrimaryElevatedButton(
              onPressed: () {}, 
              child: const Text("Edit")
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnlockedSliver() {
    return SliverPadding(
      // 1. Outer Padding (Acts like the 'margin' in your locked container)
      padding: const EdgeInsets.symmetric(horizontal: 32), 
      
      // 2. DecoratedSliver (Acts like the 'decoration' in your locked container)
      sliver: DecoratedSliver(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surfaceContainer, // Same color as locked
        ),
        
        // 3. Inner Padding (Acts like the 'padding' inside your locked container)
        sliver: SliverPadding(
          padding: const EdgeInsets.all(24), 
          
          // 4. The Content (Your existing gallery slivers)
          sliver: AlbumGallerySlivers(album: widget.album),
        ),
      ),
    );
  }
}