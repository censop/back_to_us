import 'package:back_to_us/Models/album.dart';
import 'package:back_to_us/Models/album_mode.dart';
import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/Screens/AlbumRelated/album_gallery_screen.dart';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/stacked_member_display.dart';
import 'package:flutter/material.dart';

class AlbumInfoDialog extends StatefulWidget {
  const AlbumInfoDialog({
    super.key,
    required this.album,
  });

  final Album album;
  
  @override
  State<AlbumInfoDialog> createState() => _AlbumInfoDialogState();
}

class _AlbumInfoDialogState extends State<AlbumInfoDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Album Info",
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
          fontSize: 20
        ),
        textAlign: TextAlign.center,
      ),
      contentPadding: EdgeInsets.all(20),
      contentTextStyle: Theme.of(context).textTheme.bodyLarge,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Name: ${widget.album.name}",
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 8),
          Text(
            "Mode: ${widget.album.mode.name}",
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 8),
          //to be added here
          Text(
            "Members: ",
            textAlign: TextAlign.start,
          ),
          StreamBuilder<List<AppUser>>(
            stream: FirebaseService.albumMembersStream(widget.album.members), 
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox();
              }
              
              final users = snapshot.data!;
              final displayUsers = users.toList();
              return StackedMemberDisplay(displayUsers: displayUsers, userLength: users.length,);
            }
          ),
          SizedBox(height: 8),
          Text("Opening date: ${widget.album.readableOpenAt}"),
          SizedBox(height: 8),
          widget.album.isOpen 
          ? Column(
            children: [
              Text("Album is now open!"),
              ElevatedButton(
                onPressed: _onTapOpen, 
                child: Text("Open Album"),
              ),
            ],
          )
          : Text("Time left opening date: ${widget.album.readableTimeUntilOpen}"),
          Center(
            child: ElevatedButton(
              onPressed: _onTapEdit, 
              child: Text("Edit Album"),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapEdit() {

  }

  void _onTapOpen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AlbumGalleryScreen(
          album: widget.album
        )
      )
    );
  }
}