
import 'package:back_to_us/Models/album.dart';
import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/Screens/AlbumRelated/album_screen.dart';

import 'package:back_to_us/Services/user_cache_service.dart';
import 'package:back_to_us/Widgets/album_cover.dart';
import 'package:back_to_us/Widgets/stacked_member_display.dart';
import 'package:flutter/material.dart';


class AlbumGridItem extends StatefulWidget {
  const AlbumGridItem({
    super.key,
    required this.album,
  });

  final Album album;

  @override
  State<AlbumGridItem> createState() => _AlbumGridItemState();
}

class _AlbumGridItemState extends State<AlbumGridItem> {
  final padding = 8.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap:_onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: AlbumCover(album: widget.album),
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
                    future: UserCacheService.getUsers(widget.album.members.take(3).toList()),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const SizedBox(height: 24); 
                      }
                      
                      final users = snapshot.data!;
                      
                      return StackedMemberDisplay(
                        displayUsers: users, 
                        userLength: widget.album.members.length, 
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: padding * (3/2)),
              Text(
                "Opens at: ${widget.album.readableOpenAt}",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)
                ),
              ),
              SizedBox(height: padding * 0.5),
              Text(
                widget.album.name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          )
        ],
      ),
    );
  }

  void _onTap() {

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AlbumScreen(album: widget.album))
    );
  }
}
