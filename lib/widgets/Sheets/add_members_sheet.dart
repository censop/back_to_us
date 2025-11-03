import 'package:back_to_us/Models/album_mode.dart';
import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:flutter/material.dart';

class AddMembersSheet extends StatefulWidget {
  const AddMembersSheet({
    super.key,
    required this.selectedMode,
  });

  final AlbumMode selectedMode;

  @override
  State<AddMembersSheet> createState() => _AddMembersSheetState();
}

class _AddMembersSheetState extends State<AddMembersSheet> {
  String searchQuery = "";

  List<String> selectedMembers = [];


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: Column(
        children: [
          Text(
            "Add Members",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search friends...',
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
            child: StreamBuilder<List<AppUser>>(
              stream: FirebaseService.friendsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
            
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "You haven't added any friends yet.", 
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  );
                }
            
                final allFriends = snapshot.data!;
                final filteredFriends = allFriends.where((friend) {
                  final name = friend.username.toLowerCase();
                  return name.contains(searchQuery);
                }).toList();
            
                if (filteredFriends.isEmpty) {
                  return const Center(child: Text('No friends found.'));
                }
            
                 return ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredFriends.length,
                  itemBuilder: (context, index) {
                    final friend = filteredFriends[index];

                    final isChecked = selectedMembers.contains(friend.uid);
                           
                    return ListTile(
                      leading: CustomProfilePictureDisplayer(
                        radius: 30,
                        profileUrl: friend.profilePic ?? "",
                      ),
                      title: Text(friend.username),
                      trailing: Checkbox(
                        shape: CircleBorder(),
                        checkColor: const Color.fromARGB(255, 122, 53, 69),
                        value: isChecked, 
                        onChanged: (checked) {
                          setState(() {
                            if (selectedMembers.contains(friend.uid)) {
                              selectedMembers.remove(friend.uid);
                            } else {
                              if (selectedMembers.length + 1 >= widget.selectedMode.maxPeople) {
                                // Show a short warning message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "You can only add up to ${widget.selectedMode.maxPeople} members for this album type.",
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                selectedMembers.add(friend.uid);
                              }
                            }
                          });
                        }
                      ),
                    );    
                  }               
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(selectedMembers);
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