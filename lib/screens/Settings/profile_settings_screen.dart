import 'dart:io';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Services/notifiers.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:back_to_us/Widgets/custom_settings_tiles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {

  bool _changeProfilePicture = false;

  final TextEditingController _usernameController = TextEditingController();
  bool editable = false;

  File? _image;
  final ImagePicker _imagePicker = ImagePicker();
  final ref = FirebaseStorage.instance.ref().child("profile_pictures").child(FirebaseService.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          "Edit Profile",
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),

      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                CustomProfilePictureDisplayer(
                  radius: 45,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    overlayColor: Theme.of(context).colorScheme.surface,
                  ),
                  onPressed: () {
                    setState(() {
                      _changeProfilePicture = !_changeProfilePicture;
                    });
                  }, 
                  child: Text("Edit profile picture"),
                ),
                      
                //for this use popup menu button with menu anchor
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 1),
                  child: _changeProfilePicture ?
                  Column(
                    children: [
                      TextButton(
                        onPressed: _imageFromGallery, 
                        child: Text("Choose from library"),
                      ),
                      TextButton(
                        onPressed: _imageFromCamera, 
                        child: Text("Take picture"),
                      ),
                    ],
                  )
                  : SizedBox(height:2),
                ),
              ]
            ),
          ),
          //add logic
          CustomSettingsTiles(
            leading: Text(
              "Username: ",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            mainWidget: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _usernameController,
                    enabled: editable,
                    decoration: InputDecoration(
                      hintText: FirebaseService.currentUser?.username,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  editable = !editable;
                });
              }, 
              icon: editable ? Icon(Icons.edit) : Icon(Icons.edit_off),
            ),
          ),
        ],
      ),
    );
  }

  void _imageFromGallery() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null){
      try {
        _image = File(pickedFile.path);
        await ref.putFile(_image!); 
        _updateProfilePictureUrl();
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  void _imageFromCamera() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);

    if (pickedFile != null){
      try {
        _image = File(pickedFile.path);
        await ref.putFile(_image!); 
        _updateProfilePictureUrl();
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
    
  }

  void _updateProfilePictureUrl() async {
    final url = await ref.getDownloadURL();

    FirebaseFirestore.instance
    .collection("users")
    .doc(FirebaseService.currentUser!.uid)
    .update({
      "profilePic" : url,
    });

    await FirebaseService.getAppUser();

    profilePic.value = url;
    
    print(url);
  }
}