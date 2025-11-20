import 'package:back_to_us/Models/album.dart';
import 'package:flutter/material.dart';

class AlbumCover extends StatefulWidget {
  const AlbumCover({
    super.key,
    required this.album
  });

  final Album album;

  @override
  State<AlbumCover> createState() => _AlbumCoverState();
}

class _AlbumCoverState extends State<AlbumCover> {
  final double _radius = 12;

  @override
  Widget build(BuildContext context) {
    return Card(
      /*decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        color: Theme.of(context).colorScheme.surfaceContainer
      ),*/
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: widget.album.coverPath != null && widget.album.coverPath != ""
        ? Image.network(
          widget.album.coverPath,
          fit: BoxFit.cover,
        )
        : Icon(
          Icons.add_a_photo,
        )
      ),
    );
  }
}