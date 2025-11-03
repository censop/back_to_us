
import 'package:back_to_us/Models/album_item.dart';
import 'package:back_to_us/Services/camera_service.dart';
import 'package:back_to_us/Widgets/SaveItemDisplay/photo_save_display.dart';
import 'package:back_to_us/Widgets/SaveItemDisplay/video_save_display.dart';
import 'package:back_to_us/Widgets/Sheets/select_album_sheet.dart';
import 'package:flutter/material.dart';

class SaveItemScreen extends StatefulWidget {
  const SaveItemScreen({
    super.key,
  });

  @override
  State<SaveItemScreen> createState() => _SaveItemScreenState();
}

class _SaveItemScreenState extends State<SaveItemScreen> {

  @override
  Widget build(BuildContext context) {
    AlbumItemType type = CameraService.type!;

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
      body: Column(
        children: [
          Expanded(
            child: _editWidget(type)
          ),
          Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              IconButton(
                onPressed: () {}, 
                icon: Icon(Icons.download)
              ),
              Spacer(),
              IconButton(
                onPressed: _onTapSend, 
                icon: Icon(Icons.send)
              ),
            ],
          )
        ),
        ],
      )
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

  void _onTapSend() {
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: SelectAlbumSheet(),
        );
      },
    );
  }
}