
import 'package:back_to_us/Models/album_mode.dart';
import 'package:flutter/material.dart';

class AlbumGridItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: coverPath != null
          ? Image.network(
            coverPath!,
            fit: BoxFit.fill,
          )
          : Icon(
            Icons.add_a_photo
          )
        ),
      )
    );
  }
}