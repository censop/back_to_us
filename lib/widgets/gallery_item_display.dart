import 'package:back_to_us/Models/album_item.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:flutter/material.dart';

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
        Padding(
          padding: const EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.topRight,
            child: CustomProfilePictureDisplayer(
              radius: 15,
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
        return Icon(Icons.video_camera_back);
      case AlbumItemType.voice:
        return Icon(Icons.mic);
      case AlbumItemType.text:
        return Icon(Icons.text_fields);
      case AlbumItemType.drawing:
        return Icon(Icons.color_lens);
    }
  }
}