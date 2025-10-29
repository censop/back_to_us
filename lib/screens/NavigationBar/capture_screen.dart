import 'package:back_to_us/Models/album_item.dart';
import 'package:back_to_us/Screens/save_item_screen.dart';
import 'package:back_to_us/Services/camera_service.dart';
import 'package:back_to_us/Services/notifiers.dart';
import 'package:back_to_us/Widgets/CaptureScreenButtons/capture_button.dart';
import 'package:back_to_us/Widgets/CaptureScreenModes/photo_widget.dart';
import 'package:back_to_us/Widgets/CaptureScreenModes/video_widget.dart';
import 'package:back_to_us/routes.dart';
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

  Future<XFile?> Function()? _photoCallback;
  Future<void> Function()? _startRecordingCallback;
  Future<XFile?> Function()? _stopRecordingCallback;

  bool _isRecording = false;

  final List<String> modes = [
    "Photo",
    "Video",
    "Voice",
    "Text",
    "Drawing",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text("Back\nTo\nUs"),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (value) {
                // Check if transitioning between camera and non-camera modes
                final oldUsesCamera = _usesCamera(modes[_currentPage]);
                final newUsesCamera = _usesCamera(modes[value]);
                
                setState(() {
                  _currentPage = value;
                  
                  if (oldUsesCamera && !newUsesCamera) {
                    _photoCallback = null;
                    _startRecordingCallback = null;
                    _stopRecordingCallback = null;
                  }
                });
              },
              itemCount: modes.length,
              itemBuilder: (context, index) {
                return _buildModePage(index);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                SizedBox(height: 5),               
                _buildModeButton(_currentPage),
              ],
            ),
          ),
        ],
      ),
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
              _startRecordingCallback = callback;
            }
          },
          onStopRecordingReady: (callback) {
            if (mounted) {
              _stopRecordingCallback = callback;
            }
          },
        );
      case "Voice":
        return _buildPlaceholder("🎙️ Voice Mode");
      case "Text":
        return _buildPlaceholder("✏️ Text Mode");
      case "Drawing":
        return _buildPlaceholder("🎨 Drawing Mode");
      default:
        return const SizedBox();
    }
  }

  Widget _buildModeButton(int index) {
    switch (modes[index]) {
      case "Photo":
        return CaptureButton(
          innerCircleColor: Theme.of(context).colorScheme.primary,
          onTap: _photoCallback == null
          ? null 
          : () async {
              final file = await _photoCallback!();
              if (file != null) {
                print("📸 Captured: ${file.path}");
                CameraService.imageFile = file;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SaveItemScreen(
                      type: AlbumItemType.photo
                    )
                  )
                );
              } else {
                print("⚠️ Failed to capture photo.");
              }
            },
        );
      case "Video":
        return CaptureButton(
          innerCircleColor: const Color.fromARGB(255, 155, 37, 29),
          onTap: () async {
            if (!_isRecording) {
              print("▶️ Start recording...");
              await _startRecordingCallback?.call();
              setState(() => _isRecording = true);
            } else {
              print("⏹️ Stop recording...");
              final file = await _stopRecordingCallback?.call();
              if (file != null && context.mounted) {
                CameraService.videoFile = file;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SaveItemScreen(
                      type: AlbumItemType.video,
                    ),
                  ),
                );
                setState(() => _isRecording = false);
              }
            }
          },
        );
      case "Voice":
        return _buildPlaceholder("🎙️ Voice Mode");
      case "Text":
        return _buildPlaceholder("✏️ Text Mode");
      case "Drawing":
        return _buildPlaceholder("🎨 Drawing Mode");
      default:
        return const SizedBox();
    }
  }

  bool _usesCamera(String mode) {
    return mode == "Photo" || mode == "Video";
  }


  Widget _buildPlaceholder(String label) {
    return Center(
      child: Text(
        label,
        style: const TextStyle(fontSize: 28),
      ),
    );
  }
}