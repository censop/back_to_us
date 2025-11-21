
import 'package:back_to_us/Models/album.dart';
import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/Services/user_cache_service.dart';
import 'package:back_to_us/Widgets/album_cover.dart';
import 'package:back_to_us/Widgets/stacked_member_display.dart';
import 'package:flutter/material.dart';


class AlbumGridItem extends StatelessWidget {
  const AlbumGridItem({
    super.key,
    required this.album,
  });

  final Album album;

  final padding = 8.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Hero(
            tag: album.id,
            child: AlbumCover(album: album)
          ),
        ),
        SizedBox(height: padding),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: padding),
            Row(
              children: [
                FutureBuilder<List<AppUser>>(
                  future: UserCacheService.getUsers(album.members.take(3).toList()),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const SizedBox(height: 24); 
                    }
                    
                    final users = snapshot.data!;
                    
                    return StackedMemberDisplay(
                      displayUsers: users, 
                      userLength: album.members.length, 
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: padding * (3/2)),
            Text(
              "Opens at: ${album.readableOpenAt}",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: padding * 0.5),
            Text(
              album.name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        )
      ],
    );
  }
}
