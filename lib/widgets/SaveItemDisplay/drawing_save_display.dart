import 'dart:io';

import 'package:flutter/material.dart';

class DrawingSaveDisplay extends StatefulWidget {
  const DrawingSaveDisplay({
    super.key,
    required this.file,
  });

  final File file;

  @override
  State<DrawingSaveDisplay> createState() => _DrawingSaveDisplayState();
}

class _DrawingSaveDisplayState extends State<DrawingSaveDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Image.file(widget.file),
    );
  }
}