import 'dart:io';
import 'package:back_to_us/Models/album.dart';
import 'package:back_to_us/Models/album_item.dart';
import 'package:back_to_us/Services/camera_service.dart';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Services/voice_service.dart';
import 'package:back_to_us/Widgets/custom_album_preview.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as vt;


class SelectAlbumSheet extends StatefulWidget {
  const SelectAlbumSheet({
    super.key,
    required this.type,
    required this.file,
  });

  final File file;
  final AlbumItemType type;


  @override
  State<SelectAlbumSheet> createState() => _SelectAlbumSheetState();
}

class _SelectAlbumSheetState extends State<SelectAlbumSheet> {
  String searchQuery = "";

  String? selectedAlbumId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: Column(
        children: [
          Text(
            "Select an Album",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search album...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase().trim();
                });
              },
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<Album>>(
              stream: FirebaseService.albumStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
            
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "You don't have any albums yet.", 
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  );
                }
            
                final allAlbums = snapshot.data!;
                final filteredAlbums = allAlbums.where((album) {
                  final name = album.name.toLowerCase();
                  return name.contains(searchQuery);
                }).toList();
            
                if (filteredAlbums.isEmpty) {
                  return const Center(child: Text('No albums found.'));
                }
            
                 return ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredAlbums.length,
                  itemBuilder: (context, index) {
                    final album = filteredAlbums[index];

                    bool isChecked = selectedAlbumId == album.id;
                           
                    return Column(
                      children: [
                        ListTile(
                          leading: CustomAlbumPreview(
                            coverPath: album.coverPath,
                          ),
                          title: Text(album.name),
                          trailing: Checkbox(
                            shape: CircleBorder(),
                            checkColor: const Color.fromARGB(255, 122, 53, 69),
                            value: isChecked, 
                            onChanged: (checked) {
                              setState(() {
                                selectedAlbumId = checked! ? album.id :null;
                              });
                            }
                          ),
                        ),
                        SizedBox(height:10)
                      ],
                    );    
                  }               
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () async {
                if (selectedAlbumId != null && FirebaseService.currentUser != null) {

                  final File? thumbnail = await _getThumbnail();
                  final Duration? duration = _getDuration();

                  await FirebaseService.addItemToAlbum(
                    selectedAlbumId!, 
                    widget.type, 
                    widget.file, 
                    FirebaseService.currentUser!,
                    thumbnail,
                    duration,
                  );
                  Navigator.of(context).pop(); //you need to perfect this, this is not a good solution you want to pup until the home screen
                  //add a snackbar here
                }
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: Text(
                "Done"
              ),
            ),
          ),
        ],
      ),
    );
  }

  //FOR THESE GETS, THINK OF VOICE MEMO AS WELL
  Future<File?> _getThumbnail() async {
    if (widget.type == AlbumItemType.video) { 
      try {
      final tempDir = await getTemporaryDirectory();
      final thumbPath = await vt.VideoThumbnail.thumbnailFile(
        video: widget.file.path,
        thumbnailPath: tempDir.path,
        imageFormat: vt.ImageFormat.JPEG,
        maxHeight: 200, 
        quality: 80,
      );

      if (thumbPath == null) return null;
      return File(thumbPath);
      } catch (e) {
        print('❌ Error generating thumbnail: $e');
        return null;
      }
    }
    return null;
  }

  Duration? _getDuration() {
    if (widget.type == AlbumItemType.video) {
      return CameraService.videoDuration;
    }
    else if (widget.type == AlbumItemType.voice) {
      return VoiceService.voiceDuration;
    } 
    return null;
  }
}