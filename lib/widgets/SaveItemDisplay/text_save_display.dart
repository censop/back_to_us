import 'dart:io';

import 'package:flutter/material.dart';

class TextSaveDisplay extends StatefulWidget {
  const TextSaveDisplay({
    super.key,
    required this.file
  });

  final File file;

  @override
  State<TextSaveDisplay> createState() => _TextSaveDisplayState();
}

class _TextSaveDisplayState extends State<TextSaveDisplay> {


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10)
      ),
      child: FutureBuilder<String>(
        future: _readFile(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Text(
                snapshot.data!,
                softWrap: true,
              ),
            );
          }


          return Center(
            child: Text("Preview not available"),
          );
        }
      )
    );
  }

  Future<String> _readFile() async {
    return await widget.file.readAsString();
  }
}