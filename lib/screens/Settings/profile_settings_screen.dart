import 'dart:io';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Services/notifiers.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:back_to_us/Widgets/custom_text_form_field.dart';
import 'package:back_to_us/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        actions: [
          IconButton(
            onPressed: _logOut,
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),

      //PLACEHOLDER
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
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
            Row(
              children: [
                Text("Username: "),
                Expanded(
                  child: CustomTextFormField(
                    controller: _usernameController, 
                    title: "${FirebaseService.currentUser?.username}",
                    editable: false,
                  ),
                ),
              ],
            ),
          ],
        ),
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


  void _logOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.welcome, 
      (Route<dynamic> route) => false,
    );
  }
}