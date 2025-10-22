import 'package:back_to_us/Services/camera_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhotoWidget extends StatefulWidget {
  const PhotoWidget({super.key});

  @override
  State<PhotoWidget> createState() => _PhotoWidgetState();
}

class _PhotoWidgetState extends State<PhotoWidget> {
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isActive) {
        final cameraProvider = context.read<CameraProvider>();
        if (!cameraProvider.isInitialized && !cameraProvider.isInitializing) {
          cameraProvider.initializeController(direction: CameraLensDirection.back);
        }
      }
    });
  }

  @override
  void deactivate() {
    _isActive = false;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CameraProvider>(
      builder: (context, cameraProvider, child) {
        if (cameraProvider.isInitializing || cameraProvider.isDisposing) {
          return const Center(child: CircularProgressIndicator());
        }

        final controller = cameraProvider.controller;
        if (controller == null || !controller.value.isInitialized) {
          return const Center(child: Text('Camera not available'));
        }

        return Stack(
          children: [
            Center(
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.value.previewSize!.height,
                    height: controller.value.previewSize!.width,
                    child: CameraPreview(controller),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                onPressed: (cameraProvider.isInitializing || cameraProvider.isDisposing)
                  ? null 
                  : () => cameraProvider.switchCamera(),
                icon: Icon(
                  Icons.flip_camera_ios_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}