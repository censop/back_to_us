
import 'package:back_to_us/Services/notifiers.dart';
import 'package:back_to_us/Widgets/CaptureScreenModes/photo_widget.dart';
import 'package:flutter/material.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> with WidgetsBindingObserver {
  final PageController _pageController = PageController();
  int _currentPage = 0;
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
                
                SizedBox(height: 10),
                
                InkWell(
                  onTap:() {},
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
}