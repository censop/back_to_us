import 'package:back_to_us/Models/album.dart';
import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Services/notifiers.dart';
import 'package:back_to_us/Services/user_cache_service.dart';
import 'package:back_to_us/Theme/my_app_theme.dart';
import 'package:back_to_us/Widgets/album_cover.dart';
import 'package:back_to_us/Widgets/custom_primary_elevated_button.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:back_to_us/Widgets/stacked_member_display.dart';
import 'package:back_to_us/routes.dart';
import 'package:flutter/material.dart';

class LockedAlbumScreen extends StatefulWidget {
  const LockedAlbumScreen({
    super.key,
    required this.album
  });

  final Album album;

  @override
  State<LockedAlbumScreen> createState() => _LockedAlbumScreenState();
}

class _LockedAlbumScreenState extends State<LockedAlbumScreen> {

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
              Navigator.of(context).pushNamed(
                Routes.profile,
              );
            },
          ),
          SizedBox(width: 16,)
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 400,
                  width: 325,
                  child: AlbumCover(album: widget.album)
                ),
                SizedBox(height: 12),
                Text(
                  widget.album.name,
                  style: Theme.of(context).textTheme.titleLarge
                ),
                SizedBox(height:12),
                FutureBuilder(
                  future: _getCreatorName(widget.album.owner),
                  builder: (context, snapshot) {
                    return Text(
                      "Created by ${snapshot.data ?? 'Unknown'}",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)
                      ),
                    );
                  }
                ),
                SizedBox(height:12),
                FutureBuilder<List<AppUser>>(
                  future: UserCacheService.getUsers(widget.album.members),
                  builder: (context, snapshot) {

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return SizedBox();
                    }

                    final displayUsers = snapshot.data!; 

                    return StackedMemberDisplay(displayUsers: displayUsers, userLength: displayUsers.length);
                  }
                ),
                SizedBox(height:24),
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surfaceContainer
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.lock_outlined,
                          size:100,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "This vault is locked.",
                          style: Theme.of(context).textTheme.titleLarge
                        ),
                        SizedBox(height: 8),
                        Text(
                          "It will unlock on ${widget.album.readableOpenAt}.",
                          style: Theme.of(context).textTheme.bodySmall
                        ),
                        SizedBox(height: 12),
                        CustomPrimaryElevatedButton(
                          onPressed: () {}, 
                          child: Text("Edit")
                        ),
                      ]
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> _getCreatorName(String uid) async {
    AppUser creator  = await FirebaseService.getAppUserByUid(uid);

    return creator.username;
  }
}