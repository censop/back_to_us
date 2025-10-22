import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraProvider extends ChangeNotifier {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  bool _isInitializing = false;
  bool _isDisposing = false;
  
  double _maxZoom = 1.0;
  double _minZoom = 1.0;
  double _currentZoom = 1.0;
  
  String? _capturedImagePath;
  Size? _previewSize;

  // Getters
  CameraController? get controller => _controller;
  bool get isInitialized => _controller?.value.isInitialized ?? false;
  bool get isInitializing => _isInitializing;
  bool get isDisposing => _isDisposing;
  double get maxZoom => _maxZoom;
  double get minZoom => _minZoom;
  double get currentZoom => _currentZoom;
  String? get capturedImagePath => _capturedImagePath;
  Size? get previewSize => _previewSize;

  // Initialize cameras list
  Future<void> initializeCameras() async {
    _cameras = await availableCameras();
    notifyListeners();
  }

  // Initialize camera controller
  Future<void> initializeController({
    CameraLensDirection direction = CameraLensDirection.back,
  }) async {
    if (_isInitializing || _isDisposing) return;
    _isInitializing = true;
    notifyListeners();

    try {
      if (_cameras.isEmpty) {
        await initializeCameras();
      }

      final selectedCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == direction,
        orElse: () => _cameras.first,
      );

      // Dispose old controller properly
      if (_controller != null) {
        _isDisposing = true;
        notifyListeners();
        
        try {
          if (_controller!.value.isStreamingImages) {
            await _controller!.stopImageStream();
          }
        } catch (e) {
          print('Error stopping image stream: $e');
        }
        
        await _controller!.dispose();
        _controller = null;
        
        await Future.delayed(Duration(milliseconds: 200));
        
        _isDisposing = false;
      }

      _controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();

      _previewSize = _controller!.value.previewSize;
      _maxZoom = await _controller!.getMaxZoomLevel();
      _minZoom = await _controller!.getMinZoomLevel();
      _currentZoom = _minZoom;
      
      print('✅ Camera initialized successfully');
    } catch (e) {
      print('❌ Camera initialization error: $e');
    } finally {
      _isInitializing = false;
      _isDisposing = false;
      notifyListeners();
    }
  }

  // Switch camera
  Future<void> switchCamera() async {
    if (_controller == null || _isInitializing || _isDisposing) return;

    final currentDirection = _controller!.description.lensDirection;
    final newDirection = currentDirection == CameraLensDirection.back
        ? CameraLensDirection.front
        : CameraLensDirection.back;

    await initializeController(direction: newDirection);
  }

  // Set zoom
  Future<void> setZoom(double zoom) async {
    if (_controller != null && _controller!.value.isInitialized) {
      _currentZoom = zoom;
      await _controller!.setZoomLevel(zoom);
      notifyListeners();
    }
  }

  // Take picture
  Future<XFile?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print('⚠️ Camera not initialized');
      return null;
    }
    
    if (_controller!.value.isTakingPicture) {
      print('⚠️ Already taking picture');
      return null;
    }

    try {
      final XFile file = await _controller!.takePicture();
      _capturedImagePath = file.path;
      notifyListeners();
      print('📸 Photo saved at: ${file.path}');
      return file;
    } on CameraException catch (e) {
      print('⚠️ Error taking picture: $e');
      return null;
    }
  }

  // Clear captured image
  void clearCapturedImage() {
    _capturedImagePath = null;
    notifyListeners();
  }

  // Dispose controller
  Future<void> disposeController() async {
    if (_controller != null && !_isDisposing) {
      _isDisposing = true;
      notifyListeners();
      
      try {
        if (_controller!.value.isStreamingImages) {
          await _controller!.stopImageStream();
        }
        
        await _controller!.dispose();
        _controller = null;
        print('✅ Camera controller disposed');
        
        await Future.delayed(Duration(milliseconds: 200));
      } catch (e) {
        print('Error disposing camera: $e');
      } finally {
        _isDisposing = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
    }
    super.dispose();
  }
}