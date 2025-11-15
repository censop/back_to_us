
import 'dart:io';
import 'package:back_to_us/Models/album_item.dart';
import 'package:back_to_us/Widgets/SaveItemDisplay/drawing_save_display.dart';
import 'package:back_to_us/Widgets/SaveItemDisplay/photo_save_display.dart';
import 'package:back_to_us/Widgets/SaveItemDisplay/text_save_display.dart';
import 'package:back_to_us/Widgets/SaveItemDisplay/video_save_display.dart';
import 'package:back_to_us/Widgets/SaveItemDisplay/voice_save_display.dart';
import 'package:back_to_us/Widgets/Sheets/select_album_sheet.dart';
import 'package:flutter/material.dart';

class SaveItemScreen extends StatefulWidget {
  const SaveItemScreen({
    super.key,
    required this.file,
    required this.type,
  });

  final File file;
  final AlbumItemType type;

  @override
  State<SaveItemScreen> createState() => _SaveItemScreenState();
}

class _SaveItemScreenState extends State<SaveItemScreen> {

  @override
  Widget build(BuildContext context) {
    AlbumItemType type = widget.type;
    File file = widget.file;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        title: Text("Back\nTo\nUs"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
          Expanded(
            child: Container(
              child: _editWidget(type)
            )
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
      case AlbumItemType.voice:
        return VoiceSaveDisplay(file: widget.file);
      case AlbumItemType.drawing:
        return DrawingSaveDisplay(file: widget.file);
      case AlbumItemType.text:
        return TextSaveDisplay(file: widget.file);
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
          child: SelectAlbumSheet(
            type: widget.type,
            file: widget.file
          ),
        );
      },
    );
  }
}