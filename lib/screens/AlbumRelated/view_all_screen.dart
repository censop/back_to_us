
import 'package:back_to_us/Models/album.dart';
import 'package:back_to_us/Screens/AlbumRelated/album_screen.dart';
import 'package:back_to_us/Widgets/Animations/bouncy_button.dart';
import 'package:back_to_us/Widgets/album_grid_item.dart';
import 'package:flutter/material.dart';

class ViewAllScreen extends StatefulWidget {
  const ViewAllScreen({
    super.key,
    required this.albums,
    required this.isAvailable,
  });

  final List<Album> albums;
  final bool isAvailable;

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}
class _ViewAllScreenState extends State<ViewAllScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isAvailable ? "Unlocked Vaults" : "Locked Vaults",
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3/5, 
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final album = widget.albums[index];
                  return BouncyButton(
                    onPressed: () => _onTap(album),
                    child: AlbumGridItem(album: album),
                  );
                },
                childCount: widget.albums.length, 
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTap(Album album) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AlbumScreen(album: album))
    );
  }
}