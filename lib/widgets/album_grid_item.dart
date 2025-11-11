
import 'package:back_to_us/Models/album.dart';
import 'package:back_to_us/Models/album_item.dart';
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

  final _radius = 15.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:_onTap,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_radius),
                  color: Theme.of(context).colorScheme.primary
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_radius),
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
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_radius),
                  gradient: LinearGradient(
                    colors: [const Color.fromARGB(255, 0, 0, 0), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter
                  )
                ),
              ),
            ),
            Positioned(
              bottom: 8, 
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.album.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 228, 223, 223)
                    ),
                  ),
                  Row(
                    children: [
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
                      Spacer(),
                      StreamBuilder<List<AlbumItem>>(
                        stream: FirebaseService.albumItemsStream(widget.album.id, true),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox();
                          }

                          print(snapshot.data);

                          final itemlength = snapshot.data!.length;

                          return Text("$itemlength memories");
                        }
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
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