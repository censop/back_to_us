import 'dart:io';

import 'package:back_to_us/Services/camera_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoSaveDisplay extends StatefulWidget {
  const VideoSaveDisplay({super.key});

  @override
  State<VideoSaveDisplay> createState() => _VideoSaveDisplayState();
}

class _VideoSaveDisplayState extends State<VideoSaveDisplay> {
  final XFile? _videoFile = CameraService.videoFile; 
  VideoPlayerController? _videoController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    if (_videoFile != null) {
      _videoController = VideoPlayerController.file(
        File(_videoFile.path)
      );

      _initializeVideoPlayerFuture = _videoController!.initialize();
      _videoController!.setLooping(true);
      
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator()
          );
        }

        if (_videoController != null && snapshot.connectionState == ConnectionState.done) {
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: _videoController!.value.size.width,
                          height: _videoController!.value.size.height,
                          child: VideoPlayer(_videoController!),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return Center(
            child: Text("Preview not available."),
        );
      }
    );
  }
}