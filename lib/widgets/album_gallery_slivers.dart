import 'package:back_to_us/Models/album.dart';
import 'package:back_to_us/Models/album_item.dart';
import 'package:back_to_us/Screens/AlbumRelated/fullscreen_viewer_screen.dart';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/gallery_item_display.dart';
import 'package:flutter/material.dart';

class AlbumGallerySlivers extends StatefulWidget {
  const AlbumGallerySlivers({
    super.key,
    required this.album
  });

  final Album album;

  @override
  State<AlbumGallerySlivers> createState() => _AlbumGallerySliversState();
}

class _AlbumGallerySliversState extends State<AlbumGallerySlivers> {
  bool descending = true;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Row(
            children: [
              Text(
                "Unlocked on ${widget.album.readableOpenAt}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    descending = !descending;
                  });
                },
                icon: descending
                    ? const Icon(Icons.arrow_downward)
                    : const Icon(Icons.arrow_upward),
              ),
            ],
          ),
        ),

        StreamBuilder<List<AlbumItem>>(
          stream: FirebaseService.albumItemsStream(widget.album.id, descending),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SliverToBoxAdapter(
                child: Center(child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                )),
              );
            }

            if (snapshot.data == null) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: Text("Memories cannot be displayed at the moment.")),
                ),
              );
            }

            if (snapshot.data!.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: Text("No memories in this vault.")),
                ),
              );
            }

            final items = snapshot.data!;

            return SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () {
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
                },
                childCount: items.length, 
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 1,
              ),
            );
          },
        ),
      ],
    );
  }
}