
import 'package:back_to_us/Models/album.dart';
import 'package:back_to_us/Models/album_mode.dart';
import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/album_info_dialog.dart';
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:_onTap,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.primary
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: widget.album.coverPath != null && widget.album.coverPath != ""
                ? Image.network(
                  widget.album.coverPath,
                  fit: BoxFit.cover,
                )
                : Icon(
                  Icons.add_a_photo,
                  color: Theme.of(context).colorScheme.surface,
                )
              ),
            ),
          ),
          SizedBox(height:5),
          Text(
            widget.album.name,
            overflow: TextOverflow.ellipsis,
          ),
          StreamBuilder<List<AppUser>>(
            stream: FirebaseService.albumMembersStream(widget.album.members), 
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox();
              }
              
              final users = snapshot.data!;
              final displayUsers = users.take(3).toList();
              return StackedMemberDisplay(displayUsers: displayUsers, userLength: users.length,);
            }
          ),
        ],
      ),
    );
  }

  void _onTap() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlbumInfoDialog(
          album: widget.album,
        );
      }
    );
  }
}