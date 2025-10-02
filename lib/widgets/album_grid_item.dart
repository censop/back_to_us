
import 'package:back_to_us/Models/album_mode.dart';
import 'package:flutter/material.dart';

class AlbumGridItem extends StatefulWidget {
  const AlbumGridItem({
    super.key,
    required this.coverPath,
    required this.id,
    required this.members,
    required this.mode,
    required this.name,
    required this.notificationsEnabled,
    required this.openAt
  });

  final String? coverPath;
  final String id;
  final List<String>? members;
  final AlbumMode mode;
  final String name;
  final bool notificationsEnabled;
  final DateTime openAt;

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
                child: widget.coverPath != null && widget.coverPath != ""
                ? Image.network(
                  widget.coverPath!,
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
            widget.name,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _onTap() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Album Info",
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontSize: 20
            ),
            textAlign: TextAlign.center,
          ),
          contentPadding: EdgeInsets.all(20),
          contentTextStyle: Theme.of(context).textTheme!.bodyLarge,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name: ${widget.name}",
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 8),
              Text(
                "Mode: ${widget.mode.name}",
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 8),
              //to be added here
              Text(
                "Members: ",
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 8),
              Center(
                child: ElevatedButton(
                  onPressed: () {}, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Text("Edit Album"),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}