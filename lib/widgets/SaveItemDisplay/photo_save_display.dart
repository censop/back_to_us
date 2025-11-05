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
  XFile? imageFile = CameraService.file;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        
      ],
    );
  }
}