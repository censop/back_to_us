import 'package:back_to_us/Models/album.dart';
import 'package:back_to_us/Models/album_item.dart';
import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/Screens/AlbumRelated/fullscreen_viewer_screen.dart';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/gallery_item_display.dart';
import 'package:flutter/material.dart';

class AlbumGalleryScreen extends StatefulWidget {
  const AlbumGalleryScreen({
    super.key,
    required this.album
  });

  final Album album;

  @override
  State<AlbumGalleryScreen> createState() => _AlbumGalleryScreenState();
}

class _AlbumGalleryScreenState extends State<AlbumGalleryScreen> {
  bool descending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          "Back\nTo\nUs",
        ),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                setState(() {
                  descending = !descending;
                });
              },
              icon: descending
              ? Icon(Icons.arrow_downward)
              : Icon(Icons.arrow_upward),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<AlbumItem>>(
              stream: FirebaseService.albumItemsStream(widget.album.id, descending), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.data == null) {
                  return Center(
                    child: Text("Items cannot be displayed at the moment."),
                  );
                }
                
                final items = snapshot.data;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1,
                  ), 
                  itemCount: items!.length,
                  itemBuilder: (context, index) {
                    AlbumItem item = items[index];

                    return GestureDetector(
                      onTap:() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullscreenViewerScreen(
                                items: items,
                                initialIndex: index, 
                              ),
                            ),
                          );
                        },
                      child: GalleryItemDisplay(item: item),
                    );
                  }
                );

              }
            )
          )
        ]
      )
    );
  }
}