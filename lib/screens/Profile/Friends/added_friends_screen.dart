import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:flutter/material.dart';

class AddedFriendsScreen extends StatefulWidget {
  const AddedFriendsScreen({super.key});

  @override
  State<AddedFriendsScreen> createState() => _AddedFriendsScreenState();
}

class _AddedFriendsScreenState extends State<AddedFriendsScreen> {
  
  String searchQuery = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Added Friends"),
        centerTitle: true,
      ),

      body: Column(
        children: [
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
          StreamBuilder<List<AppUser>>(
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
          
               return Flexible(
                 child: ListView.builder(
                  itemCount: filteredFriends.length,
                  itemBuilder: (context, index) {
                    final friend = filteredFriends[index];
                           
                    return ListTile(
                      leading: CustomProfilePictureDisplayer(
                        radius: 30,
                        profileUrl: friend.profilePic ?? "",
                      ),
                      title: Text(friend.username),
                    );    
                  }               
                ),
              );
            },
          ),
        ],
      )
    );
  }
}