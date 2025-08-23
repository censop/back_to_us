import 'package:flutter/material.dart';

class CreateAlbumSheet extends StatefulWidget {
  const CreateAlbumSheet({super.key});

  @override
  State<CreateAlbumSheet> createState() => _CreateAlbumSheetState();
}

class _CreateAlbumSheetState extends State<CreateAlbumSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Album name"),
        Text("Duration of album"),
        Text("Mode"),
        Text("Additional user invites according to the mode"),
      ],
    );
  }
}