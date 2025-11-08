import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:back_to_us/Widgets/drawing_painter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class DrawingWidget extends StatefulWidget {
  const DrawingWidget({
    super.key,
    required this.onSaveReady,
  });

  // 👇 This callback will send a function back to CaptureScreen
  final void Function(Future<File?> Function()?) onSaveReady;
  @override
  State<DrawingWidget> createState() => _DrawingWidgetState();
}

class _DrawingWidgetState extends State<DrawingWidget> {
  final GlobalKey _canvasKey = GlobalKey();
  final List<List<Offset>> _paths = [];
  final List<Color> _colors = [];
  Color _selectedColor = Colors.black;

  @override
  void initState() {
    super.initState();
    widget.onSaveReady(_saveDrawingToFile);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: _undo, 
              icon: Icon(Icons.undo)
            ),
            IconButton(
              onPressed: _pickColor, 
              icon: Icon(Icons.color_lens)
            )
          ],
        ),
        Expanded(
          child: GestureDetector(
            onPanStart: (details) {
              setState(() {
                _paths.add([details.localPosition]);
                _colors.add(_selectedColor);
              });
            },
          
            onPanUpdate: (details) {
              setState(() {
                _paths.last.add(details.localPosition);
              });
            },
            child: RepaintBoundary(
              key: _canvasKey,
              child: CustomPaint(
                painter: DrawingPainter(
                  paths: _paths, 
                  colors: _colors
                ),
                size: Size.infinite,
              ),
            ),
          ),
        )
      ],
    );
  }

  void _undo() {
    if (_paths.isNotEmpty) {
      setState(() {
        _paths.removeLast();
        _colors.removeLast();
      });
    }
  }



  //this is just for now, another mechanism will be made here
  void _pickColor() async {
    Color? pickedColor = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pick a color"),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Colors.black,
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                  Colors.purple,
                  Colors.brown,
                  Colors.grey,
                  Colors.pink,
                  Colors.yellow,
                  Colors.cyan,
                  Colors.teal,
                  Colors.lime,
                  Colors.indigo,
                  Colors.amber,
                ].map((color) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, color);
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );

    if (pickedColor != null) {
      setState(() {
        _selectedColor = pickedColor;
      });
    }
  }

  Future<File?> _saveDrawingToFile() async {
    try {
      RenderRepaintBoundary boundary =
          _canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/drawing_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      return file;
    } catch (e) {
      debugPrint("Error saving drawing: $e");
      return null;
    }
  }
}