import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakePhotoButton extends StatefulWidget {
  const TakePhotoButton({
    super.key,
    required this.controller
  });

  final controller;

  @override
  State<TakePhotoButton> createState() => _TakePhotoButtonState();
}

class _TakePhotoButtonState extends State<TakePhotoButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _takePicture,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.circle,
            color: Theme.of(context).colorScheme.primary,
            size: 70
          ),
          Icon(
            Icons.circle,
            color: Theme.of(context).colorScheme.surface,
            size: 60
          ),
        ],
      ),
    );
  }


  Future<void> _takePicture() async {
    if (widget.controller == null || !widget.controller!.value.isInitialized) {
      print('⚠️ Camera not initialized');
      return;
    }
    
    if (widget.controller!.value.isTakingPicture) {
      print('⚠️ Already taking picture');
      return;
    }

    try {
      final XFile file = await widget.controller!.takePicture();
      print('📸 Photo saved at: ${file.path}');
      return;
    } on CameraException catch (e) {
      print('⚠️ Error taking picture: $e');
      return;
    }
  }

}