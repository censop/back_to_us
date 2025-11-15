import 'package:back_to_us/Models/album_item.dart';
import 'package:back_to_us/Widgets/ItemViewerWidgets/video_viewer.dart';
import 'package:back_to_us/Widgets/ItemViewerWidgets/voice_viewer.dart';
import 'package:flutter/material.dart';

class FullscreenViewerScreen extends StatefulWidget {
  const FullscreenViewerScreen({
    super.key,
    required this.items,
    required this.initialIndex,
  });

  final List<AlbumItem> items;
  final int initialIndex;

  @override
  State<FullscreenViewerScreen> createState() => _FullscreenViewerScreenState();
}

class _FullscreenViewerScreenState extends State<FullscreenViewerScreen> {
  late PageController _controller;
  late int _currentIndex;


  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          "Back\nTo\nUs",
        ),
      ),

      body: PageView.builder(
        onPageChanged: (i) {
          setState(() {
            _currentIndex = i;
          });
        },
        controller: _controller,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final AlbumItem item = widget.items[index];

          return Center(
            child: _fullscreenItem(item),
          );
        }
      ),
    );
  }

  Widget _fullscreenItem(AlbumItem item) {
    switch (item.type) {
      case AlbumItemType.drawing:
        return InteractiveViewer(
          child: Image.network(item.downloadUrl, fit: BoxFit.contain),
        );
      case AlbumItemType.text:
        return Padding(
          padding: EdgeInsets.all(8),
          child: Text(item.textContent ?? "Preview not available"),
        );
      case AlbumItemType.video:
        return VideoViewer(item: item);
      case AlbumItemType.voice:
        return VoiceViewer(item: item);
      case AlbumItemType.photo:
        return InteractiveViewer(
          child: Image.network(item.downloadUrl, fit: BoxFit.contain),
        );
    }
  }


}