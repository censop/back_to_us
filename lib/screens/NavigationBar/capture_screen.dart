import 'package:back_to_us/Services/camera_provider.dart';
import 'package:back_to_us/Services/notifiers.dart';
import 'package:back_to_us/Widgets/CaptureScreenModes/photo_widget.dart';
import 'package:back_to_us/routes.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> with WidgetsBindingObserver {
  final PageController _pageController = PageController();
  late final CameraProvider _cameraProvider;
  int _currentPage = 0;
  final List<String> modes = [
    "Photo",
    "Video",
    "Voice",
    "Text",
    "Drawing",
  ];

  @override
  void initState() {
    super.initState();
    _cameraProvider = context.read<CameraProvider>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    _cameraProvider.disposeController();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    final cameraProvider = context.read<CameraProvider>();
    
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      cameraProvider.disposeController();
    } else if (state == AppLifecycleState.resumed && _currentPage == 0) {
      cameraProvider.initializeController(direction: CameraLensDirection.back);
    }
  }

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
                
                // Zoom slider for photo/video
                if (_currentPage == 0 || _currentPage == 1)
                  Consumer<CameraProvider>(
                    builder: (context, cameraProvider, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          children: [
                            Text('1x', style: TextStyle(fontSize: 12)),
                            Expanded(
                              child: Slider(
                                value: cameraProvider.currentZoom,
                                min: cameraProvider.minZoom,
                                max: cameraProvider.maxZoom,
                                onChanged: (value) => cameraProvider.setZoom(value),
                              ),
                            ),
                            Text('${cameraProvider.maxZoom.toStringAsFixed(1)}x', 
                              style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    },
                  ),
                
                SizedBox(height: 10),
                
                InkWell(
                  onTap: _onCapture,
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
                ),
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
        return PhotoWidget();
      case "Video":
        return _buildPlaceholder("🎥 Video Mode");
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

  Future<void> _onCapture() async {
    if (_currentPage == 0) {
      final cameraProvider = context.read<CameraProvider>();
      final file = await cameraProvider.takePicture();

      if (file != null && mounted) {
        await Navigator.of(context).pushNamed(Routes.saveItem);
        
        if (mounted) {
          await cameraProvider.initializeController(direction: CameraLensDirection.back);
        }
      }
    }
  }
}