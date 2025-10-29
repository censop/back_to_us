
import 'package:back_to_us/Models/album_item.dart';
import 'package:back_to_us/Widgets/SaveItemDisplay/photo_save_display.dart';
import 'package:back_to_us/Widgets/SaveItemDisplay/video_save_display.dart';
import 'package:flutter/material.dart';

class SaveItemScreen extends StatefulWidget {
  const SaveItemScreen({
    super.key,
    required this.type
  });

  final AlbumItemType type;

  @override
  State<SaveItemScreen> createState() => _SaveItemScreenState();
}

class _SaveItemScreenState extends State<SaveItemScreen> {

  @override
  Widget build(BuildContext context) {
    AlbumItemType type = widget.type;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
        automaticallyImplyLeading: false,
        title: Text("Back\nTo\nUs"),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: _editWidget(type)
    );
  }

  Widget _editWidget(type) {
    switch (type) {
      case AlbumItemType.photo:
        return PhotoSaveDisplay();
      case AlbumItemType.video:
        return VideoSaveDisplay();
      case AlbumItemType.drawing:
        return Text("Placeholder");
      case AlbumItemType.voice:
        return Text("Placeholder");
      case AlbumItemType.text:
        return Text("Placeholder");
      default:
        return Text("Image not loading");
    }
  }
}