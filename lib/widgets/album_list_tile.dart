import 'package:flutter/material.dart';

class AlbumListTile extends StatelessWidget {
  const AlbumListTile({
    super.key,
    required this.color, //will change this with imageURL
    required this.title
  });

  final Color color;
  final String title;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        height: 50,
        width: 50,
      ),
      title: Text(title),
    );
  }
}