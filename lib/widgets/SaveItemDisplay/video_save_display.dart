import 'dart:io';

import 'package:back_to_us/Services/camera_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

//DOESNT WORKKKK NEED TO DEBUG

class VideoSaveDisplay extends StatefulWidget {
  const VideoSaveDisplay({super.key});

  @override
  State<VideoSaveDisplay> createState() => _VideoSaveDisplayState();
}

class _VideoSaveDisplayState extends State<VideoSaveDisplay> {
  late XFile? _videoFile;
  VideoPlayerController? _videoController;
  late Future<void> _initializeVideoPlayerFuture = Future.value();

  @override
  void initState() {
    super.initState();
    _initVideo();
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

  Future<void> _initVideo() async {
    _videoFile = CameraService.file;
    if (_videoFile == null) return;

    final controller = VideoPlayerController.file(File(_videoFile!.path));
    await controller.initialize();
    controller.setLooping(true);

    setState(() {
      _videoController = controller;
      _initializeVideoPlayerFuture = Future.value();
    });

    _videoController!.play(); 
  }
}