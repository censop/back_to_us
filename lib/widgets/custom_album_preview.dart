import 'package:flutter/material.dart';

class CustomAlbumPreview extends StatelessWidget {
  const CustomAlbumPreview({
    super.key,
    required this.coverPath
  });

  final String? coverPath;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.primary
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: coverPath != null && coverPath != ""
          ? Image.network(
            coverPath!,
            fit: BoxFit.cover,
          )
          : Icon(
            Icons.add_a_photo,
            color: Theme.of(context).colorScheme.surface,
          )
        ),
      ),
    );
  }
}