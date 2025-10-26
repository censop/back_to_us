
import 'package:back_to_us/Services/camera_service.dart';
import 'package:back_to_us/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({
    super.key,
    required this.onStartRecordingReady,
    required this.onStopRecordingReady,
  });

  final void Function(Future<void> Function()?) onStartRecordingReady;
  final void Function(Future<XFile?> Function()?) onStopRecordingReady;

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> with WidgetsBindingObserver, RouteAware {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    onNewCameraSelected(CameraService.backCamera);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didPushNext() {
    _controller?.dispose();
    _controller = null;
    _isCameraInitialized = false;
  }

  @override
  void didPopNext() {
    onNewCameraSelected(CameraService.backCamera);
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
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: Text("Camera not available"));
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

      widget.onStartRecordingReady?.call(startRecording);
      widget.onStopRecordingReady?.call(stopRecording);
    }
  }

  Future<void> startRecording() async {
    if (_controller == null || !_controller!.value.isInitialized || _controller!.value.isRecordingVideo) return;
    try {
      await _controller!.startVideoRecording();
      setState(() => _isRecording = true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<XFile?> stopRecording() async {
    if (_controller == null || !_controller!.value.isInitialized || !_isRecording|| !_controller!.value.isRecordingVideo) return null;

    try {
      final XFile file = await _controller!.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
      return file;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}