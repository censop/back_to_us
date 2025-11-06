import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TextWidget extends StatefulWidget {
  const TextWidget({
    super.key,
    required this.onSaveReady,
  });

  final Function(Future<File?> Function())? onSaveReady;

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    super.initState();
    widget.onSaveReady?.call(_saveTextToFile);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  //will add stuff to choose font, color etc,
                }, 
                icon: Icon(Icons.text_fields)
              ),
              IconButton(
                onPressed: () {
                  //will add stuff to choose font, color etc,
                }, 
                icon: Icon(Icons.color_lens)
              ),
            ],
          ),
          SingleChildScrollView(
            child: TextFormField(
              controller: _controller,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Start typing...",
                border: InputBorder.none
              ),
            ),
          ),
        ],
      )
    );
  }

  Future<File?> _saveTextToFile() async {
    try {
      final text = _controller.text.trim();
      if (text.isEmpty) return null;

      // Get app's temporary directory
      final dir = await getTemporaryDirectory();

      // Create a file name with timestamp
      final filePath = '${dir.path}/note_${DateTime.now().millisecondsSinceEpoch}.txt';
      final file = File(filePath);

      // Write text content
      await file.writeAsString(text);

      debugPrint('Text saved as file → $filePath');
      return file;
    } catch (e) {
      debugPrint('Error saving text: $e');
      return null;
    }
  }

}