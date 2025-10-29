import 'dart:io';

import 'package:back_to_us/Services/camera_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PhotoSaveDisplay extends StatefulWidget {
  const PhotoSaveDisplay({super.key});

  @override
  State<PhotoSaveDisplay> createState() => _PhotoSaveDisplayState();
}

class _PhotoSaveDisplayState extends State<PhotoSaveDisplay> {
  XFile? imageFile = CameraService.imageFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close),
            ),
          ],
        ),
        SizedBox(height: 10),
        Expanded(
          child: Center(
            child: imageFile == null
              ? Text("An error occured while taking a picture.")   
              : Padding(
              padding: EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(imageFile!.path),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Add to album",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // add save logic and snackbar
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  "Save",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}