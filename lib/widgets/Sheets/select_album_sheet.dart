import 'dart:io';

import 'package:back_to_us/Models/album.dart';
import 'package:back_to_us/Models/album_item.dart';
import 'package:back_to_us/Services/camera_service.dart';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/custom_album_preview.dart';
import 'package:back_to_us/routes.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
                  await FirebaseService.addItemToAlbum(
                    selectedAlbumId!, 
                    widget.type, 
                    widget.file, 
                    FirebaseService.currentUser!
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
}