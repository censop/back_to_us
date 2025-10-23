import 'package:back_to_us/Services/camera_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PhotoWidget extends StatefulWidget {
  const PhotoWidget({super.key});

  @override
  State<PhotoWidget> createState() => _PhotoWidgetState();
}

class _PhotoWidgetState extends State<PhotoWidget> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    onNewCameraSelected(CameraService.backCamera);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    }

    else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }

  }


  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(
        child: Text('Camera not available'),
      );
    }

    return Stack(
          children: [
            Center(
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.previewSize!.height,
                    height: _controller!.value.previewSize!.width,
                    child: CameraPreview(_controller!),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _isCameraInitialized = false;
                  });
                  onNewCameraSelected(
                    _controller!.description == CameraService.backCamera
                    ? CameraService.frontCamera 
                    : CameraService.backCamera
                  );
                },
                icon: Icon(
                  Icons.flip_camera_ios_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ],
        );
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
      final previousCameraController = _controller;
      final CameraController cameraController = CameraController(
        cameraDescription,
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await previousCameraController?.dispose();

      if (mounted) {
         setState(() {
           _controller = cameraController;
        });
      }

      cameraController.addListener(() {
        if (mounted) setState(() {});
      });

      try {
        await cameraController.initialize();
      } on CameraException catch (e) {
        print('Error initializing camera: $e');
      }

      if (mounted) {
        setState(() {
           _isCameraInitialized = _controller!.value.isInitialized;
        });
      }
   }

   Future<XFile?> takePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) return null;

    if (_controller!.value.isTakingPicture) {
      return null;
    }

    try {
      XFile file = await _controller!.takePicture();
      return file;
    } catch(e) {
      print(e);
      return null;
    }
  }
}