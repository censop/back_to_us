import 'dart:io';
import 'package:back_to_us/Models/album_item.dart';
import 'package:back_to_us/Screens/save_item_screen.dart';
import 'package:back_to_us/Services/camera_service.dart';
import 'package:back_to_us/Services/notifiers.dart';
import 'package:back_to_us/Widgets/CaptureScreenButtons/capture_button.dart';
import 'package:back_to_us/Widgets/CaptureScreenModes/drawing_widget.dart';
import 'package:back_to_us/Widgets/CaptureScreenModes/text_widget.dart';
import 'package:back_to_us/Widgets/CaptureScreenModes/voice_widget.dart';
import 'package:back_to_us/Widgets/CaptureScreenModes/photo_widget.dart';
import 'package:back_to_us/Widgets/CaptureScreenModes/video_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> with WidgetsBindingObserver {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  File? capturedFile;
  AlbumItemType? capturedType;


  Future<XFile?> Function()? _photoCallback;
  Future<void> Function()? _startVideoRecordingCallback;
  Future<XFile?> Function()? _stopVideoRecordingCallback;

  Future<void> Function()? _startVoiceRecordingCallback;
  Future<File?> Function()? _stopVoiceRecordingCallback;

  Future<File?> Function()? _saveTextFileCallback;

  Future<File?> Function()? _saveDrawingCallback; 


  bool _isRecordingVideo = false;
  bool _isRecordingVoice = false;

  final List<String> modes = [
    "Photo",
    "Video",
    "Voice",
    "Text",
    "Drawing",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  final oldUsesCamera = _usesCamera(modes[_currentPage]);
                  final newUsesCamera = _usesCamera(modes[value]);
                  
                  setState(() {
                    _currentPage = value;
                    
                    if (oldUsesCamera && !newUsesCamera) {
                      _photoCallback = null;
                      _startVideoRecordingCallback = null;
                      _stopVideoRecordingCallback = null;
                    }
                  });
                },
                itemCount: modes.length,
                itemBuilder: (context, index) {
                  return _buildModePage(index);
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildModeButton(_currentPage)
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [               
              ValueListenableBuilder(
                valueListenable: darkModeNotifier,
                builder: (context, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(modes.length, (index) {
                      final isActive = _currentPage == index;
                      return GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            modes[index].toUpperCase(),
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: value 
                                ? (isActive ? Colors.white : Colors.white54) 
                                : (isActive ? Colors.black : const Color.fromARGB(255, 123, 123, 123)),
                              fontSize: isActive ? 18 : 14,
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModePage(int index) {
    final isVisible = index == _currentPage;
    
    switch (modes[index]) {
      case "Photo":
        return PhotoWidget(
          key: ValueKey('photo-$isVisible'),
          isVisible: isVisible,
          onCaptureReady: (callback) {
            if (mounted) {
              setState(() {
                _photoCallback = callback;
              });
            }
          },
        );
      case "Video":
        return VideoWidget(
          key: ValueKey('video-$isVisible'),
          isVisible: isVisible,
          onStartRecordingReady: (callback) {
            if (mounted) {
              _startVideoRecordingCallback = callback;
            }
          },
          onStopRecordingReady: (callback) {
            if (mounted) {
              _stopVideoRecordingCallback = callback;
            }
          },
        );
      case "Voice":
        return VoiceWidget(
          onStartRecordingReady: (callback) {
            _startVoiceRecordingCallback = callback;
          },
          onStopRecordingReady: (callback) {
            _stopVoiceRecordingCallback = callback;
          },
        );
      case "Text":
        return TextWidget(
          onSaveReady: (callback) {
            _saveTextFileCallback = callback;
          },
        );
      case "Drawing":
        return DrawingWidget(
          onSaveReady: (callback) {
            _saveDrawingCallback = callback;
          },
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildModeButton(int index) {
    switch (modes[index]) {
      case "Photo":
        return CaptureButton(
          innerCircleColor: Theme.of(context).colorScheme.primary,
          onTap: () async {
            final file = await _photoCallback!();
            if (file != null) {
              print("📸 Captured: ${file.path}");
              CameraService.file = file;
              capturedFile = File(file.path);
              CameraService.type = AlbumItemType.photo;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SaveItemScreen(
                    type: AlbumItemType.photo,
                    file: capturedFile!
                  )
                )
              );
            } else {
              print("⚠️ Failed to capture photo.");
            }
          },
        );
      case "Video": //make this like snapchat, it records as you press
        return CaptureButton(
          innerCircleColor: const Color.fromARGB(255, 155, 37, 29),
          onTap: () async {
            if (!_isRecordingVideo) {
              print("Start recording video...");
              await _startVideoRecordingCallback?.call();
              setState(() => _isRecordingVideo = true);
            } else {
              print("Stop recording video...");
              final file = await _stopVideoRecordingCallback?.call();
              if (file != null && context.mounted) {
                CameraService.file = file;
                capturedFile = File(file.path);
                CameraService.type = AlbumItemType.video;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SaveItemScreen(
                      type: AlbumItemType.video,
                      file: capturedFile!,
                    ),
                  ),
                );
                setState(() => _isRecordingVideo = false);
              }
            }
          },
        );
      case "Voice":
        return CaptureButton(
          innerCircleColor: const Color.fromARGB(255, 155, 37, 29),
          onTap: () async {
            if (!_isRecordingVoice) {
              print("Start recording voice...");
              await _startVoiceRecordingCallback?.call();
              setState(() => _isRecordingVoice = true);
            } else {
              print("Stop recording voice...");
              final file = await _stopVoiceRecordingCallback?.call();
              if (file != null && context.mounted) {
                capturedFile = file;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SaveItemScreen(
                      type: AlbumItemType.voice,
                      file: capturedFile!,
                    ),
                  ),
                );
                setState(() => _isRecordingVoice = false);
              }
            }
          },
        );
      case "Text":
        return CaptureButton(
          innerCircleColor: Theme.of(context).colorScheme.primary,
          onTap: () async {
            if (_saveTextFileCallback == null) return;

            final file = await _saveTextFileCallback!.call();
            if (file != null && context.mounted) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SaveItemScreen(
                    type: AlbumItemType.text,
                    file: file,
                  ),
                ),
              );
            } else {
              print("There should be a snackbar regarding this.");
              //add custom snackbar here and to drawing in case there is no content
            }
          },
        );
      case "Drawing":
        return CaptureButton(
          innerCircleColor: Theme.of(context).colorScheme.primary,
          onTap: () async {
            if (_saveDrawingCallback == null) return;

            final file = await _saveDrawingCallback!.call();
            if (file != null && context.mounted) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SaveItemScreen(
                    type: AlbumItemType.drawing, 
                    file: file,
                  ),
                ),
              );
            } else {
              print("There should be a snackbar regarding this.");
            }
          },
        );  
      default:
        return const SizedBox();
    }
  }

  bool _usesCamera(String mode) {
    return mode == "Photo" || mode == "Video";
  }
}