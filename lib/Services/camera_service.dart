
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

class CameraService {
  static List<CameraDescription> _cameras = [];
  static CameraController? _controller;

  static double maxZoom = 1.0;
  static double minZoom = 1.0;

  static Future<void> initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
  }

  static Future<CameraController> createController({
    CameraLensDirection direction = CameraLensDirection.back,
  }) async {
    await initialize();

    final camera = _cameras.firstWhere(
      (c) => c.lensDirection == direction,
      orElse: () => _cameras.first,
    );

    final controller = CameraController(camera, ResolutionPreset.high, enableAudio: false);
    await controller.initialize();

    maxZoom = await controller.getMaxZoomLevel();
    minZoom = await controller.getMinZoomLevel();

    return controller;
  }

  // Take picture
  static Future<XFile?> takePicture(CameraController controller) async {
    if (controller.value.isTakingPicture || !controller.value.isInitialized) {
      return null;
    }

    try {
      final XFile file = await controller!.takePicture();
      print('📸 Photo saved at: ${file.path}');
      return file;
    } on CameraException catch (e) {
      print('⚠️ Error taking picture: $e');
      return null;
    }
  }

}