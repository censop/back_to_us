import 'dart:io';

import 'package:back_to_us/Models/album_item.dart';
import 'package:back_to_us/Services/cache_service.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class GalleryItemDisplay extends StatefulWidget {
  const GalleryItemDisplay({
    super.key,
    required this.item,
  });

  final AlbumItem item;

  @override
  State<GalleryItemDisplay> createState() => _GalleryItemDisplayState();
}

class _GalleryItemDisplayState extends State<GalleryItemDisplay> {
  final double _radius = 5;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_radius),
              color: Colors.black
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_radius),
              child: _display(widget.item)
            ),
          ),
        ),
        widget.item.duration != 0 && widget.item.duration != null 
        ? Padding(
          padding: const EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.bottomRight,
            child: _durationDisplay(widget.item.duration!)
          ),
        )
        : SizedBox(),
        Padding(
          padding: EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.topRight,
            child: _itemTypeIcon(widget.item, 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: CustomProfilePictureDisplayer(
              radius: 10,
              profileUrl: widget.item.createdBy.profilePic ?? "",
            ),
          ),
        ),
      ] 
    );
  }


  Widget _display(AlbumItem item) {
    switch(item.type) {
      case AlbumItemType.photo:
        return Image.network(
          item.downloadUrl,
          fit: BoxFit.cover,
        );
      case AlbumItemType.video:
        return item.thumbnailUrl != null
        ? Image.network(
          item.thumbnailUrl!,
          fit: BoxFit.cover,
        )
        : Icon(Icons.video_camera_back);
      case AlbumItemType.voice:
        return Icon(Icons.mic);
      case AlbumItemType.text:
        return FutureBuilder(
          future: CacheService.loadTextFromUrlWithCache(item.downloadUrl, item.id), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Empty note"));
            }
            final text = snapshot.data!;
            return Container(
              color: const Color.fromARGB(255, 20, 20, 20),
              padding: const EdgeInsets.all(10),
              child: Text(
                text.length > 100 ? "${text.substring(0, 100)}..." : text,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.3,
                ),
                overflow: TextOverflow.fade,
              ),
            );
          }
        );
      case AlbumItemType.drawing:
        return Image.network(
          item.downloadUrl,
          fit: BoxFit.cover,
        );
    }
  }

  Icon _itemTypeIcon(AlbumItem item, double size) {
    switch(item.type) {
      case AlbumItemType.photo:
        return Icon(Icons.camera_alt, size: size);
      case AlbumItemType.video:
        return Icon(Icons.video_camera_back, size: size);
      case AlbumItemType.voice:
        return Icon(Icons.mic, size: size);
      case AlbumItemType.text:
        return Icon(Icons.text_fields, size: size);
      case AlbumItemType.drawing:
        return Icon(Icons.color_lens, size: size);
    }
  }

  Widget _durationDisplay(Duration duration) {
    return  Container(
      height: 15,
      width: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(146, 26, 26, 26),
      ),
      child: Center(
        child: Text(
          "${duration.inMinutes.toString().padLeft(2, "0")}:${duration.inSeconds.toString().padLeft(2, "0")}",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: 10
          )
        ),
      ),
    );
  }
}