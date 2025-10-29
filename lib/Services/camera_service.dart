import 'dart:ui';
import 'package:camera/camera.dart';

class CameraService {
  static List<CameraDescription> _cameras = [];

  static double maxZoom = 1.0;
  static double minZoom = 1.0;
  static XFile? imageFile;
  static XFile? videoFile;

  // Initialize cameras on app start
  static Future<void> initialize() async {
    _cameras = await availableCameras();
  }

  static Future<void> getAvailableZoom(CameraController controller) async {
      maxZoom = await controller.getMaxZoomLevel();
      minZoom = await controller.getMinZoomLevel();
  }
  // Getters
  static List<CameraDescription> get cameras => _cameras;

  static CameraDescription get frontCamera => _cameras.firstWhere(
    (camera) => camera.lensDirection == CameraLensDirection.front,
    orElse: () => _cameras.first,
  );

  static CameraDescription get backCamera => _cameras.firstWhere(
    (camera) => camera.lensDirection == CameraLensDirection.back,
    orElse: () => _cameras.first,
  );

  // Switch between front and back camera
  static Future<CameraLensDirection> switchCamera(CameraController controller) async {
    final currentDirection = controller.description.lensDirection;
    final newDirection = currentDirection == CameraLensDirection.back
        ? CameraLensDirection.front
        : CameraLensDirection.back;

    return newDirection;
  }

}