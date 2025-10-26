
import 'dart:io';

import 'package:back_to_us/Services/camera_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class SaveItemScreen extends StatefulWidget {
  const SaveItemScreen({
    super.key,
    required this.file
  });

  final XFile file;

  @override
  State<SaveItemScreen> createState() => _SaveItemScreenState();
}

class _SaveItemScreenState extends State<SaveItemScreen> {

  @override
  Widget build(BuildContext context) {
    XFile? imageFile = widget.file;


    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
        automaticallyImplyLeading: false,
        title: Text("Back\nTo\nUs"),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: Center(
                  child: imageFile == null
                    ? Text("An error occured while taking a picture.")   
                    : Padding(
                    padding: EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(imageFile.path),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Add to album",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Save logic here
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Saved to album!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: Text(
                        "Save",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}