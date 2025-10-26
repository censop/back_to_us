
import 'package:back_to_us/Screens/save_item_screen.dart';
import 'package:back_to_us/Services/camera_service.dart';
import 'package:back_to_us/Services/notifiers.dart';
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
                setState(() {
                  _currentPage = value;
                });
              },
              itemCount: modes.length,
              itemBuilder: (context, index) {
                return _buildModePage(index);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
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
                SizedBox(height: 20),               
                _buildModeButton(_currentPage),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModePage(int index) {
    switch (modes[index]) {
      case "Photo":
        return PhotoWidget(
          onCaptureReady: (callback) {
            setState(() {
              _photoCallback = callback;
            });
          },
        );
      case "Video":
        return VideoWidget(
          onStartRecordingReady: (callback) {
            _startRecordingCallback = callback;
          },
          onStopRecordingReady: (callback) {
            _stopRecordingCallback = callback;
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
        return GestureDetector(
          onTap: _photoCallback == null
          ? null // disables tap if camera not ready
          : () async {
              final file = await _photoCallback!();
              if (file != null) {
                print("📸 Captured: ${file.path}");
                CameraService.imageFile = file;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SaveItemScreen(file: file)
                  )
                );
              } else {
                print("⚠️ Failed to capture photo.");
              }
            },
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
      case "Video":
        return GestureDetector(
          onTapDown: (_) async {
            await _startRecordingCallback?.call();
          },
          onTapUp: (_) async {
            final file = await _stopRecordingCallback?.call();
            if (file != null && context.mounted) {
              CameraService.videoFile = file;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SaveItemScreen(file: file)
                )
              );
            }
          },
          onTapCancel: () async {
            final file = await _stopRecordingCallback?.call();
            if (file != null && context.mounted) {
              CameraService.videoFile = file;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SaveItemScreen(file: file)
                )
              );
            }
          },

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
                color: const Color.fromARGB(255, 174, 42, 32),
                size: 60
              ),
            ],
          ),
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

  Widget _buildPlaceholder(String label) {
    return Center(
      child: Text(
        label,
        style: const TextStyle(fontSize: 28),
      ),
    );
  }
}