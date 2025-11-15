
import 'dart:io';
import 'package:back_to_us/Models/album_mode.dart';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Services/notifiers.dart';
import 'package:back_to_us/Widgets/Sheets/add_members_sheet.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:back_to_us/Widgets/custom_settings_tiles.dart';
import 'package:back_to_us/Widgets/custom_snackbar.dart';
import 'package:back_to_us/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class CreateAlbumScreen extends StatefulWidget {
  const CreateAlbumScreen({super.key});

  @override
  State<CreateAlbumScreen> createState() => _CreateAlbumScreenState();
}

class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
  final _formKey = GlobalKey<FormState>();

  //dummy members, logic not implemented yet
  List<String> members = [];
  
  File? _image;
  final ImagePicker _imagePicker = ImagePicker();

  bool _imageLoading = false;

  String? selectedMode = "Single";
  DateTime selectedDate = DateTime.now();

  final TextEditingController _albumNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  //to be changed
  bool notificationsOn = true;
  
  @override
  void dispose() {
    _albumNameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = dateToString(selectedDate);
  }

  //dummy mode items
  List<DropdownMenuItem<String>> modes = [
    DropdownMenuItem(
      value: "Single",
      child: Text("Single", overflow: TextOverflow.ellipsis,)
    ),
    DropdownMenuItem(
      value: "Couple",
      child: Text("Couple", overflow: TextOverflow.ellipsis)
    ),
    DropdownMenuItem(
      value: "Friends",
      child: Text("Friends", overflow: TextOverflow.ellipsis)
    ),
    DropdownMenuItem(
      value: "Friends+",
      child: Text("Friends+", overflow: TextOverflow.ellipsis)
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create an Album",
        ),
        actions: [
          CustomProfilePictureDisplayer(
            radius: 30,
            onPressed: () {
              Navigator.of(context).pushNamed(
                Routes.profile,
              );
            },
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () async {
                setState(() {
                  _imageLoading = true;
                });
                await _imageFromGallery();
                setState(() {
                  _imageLoading = false;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 5
                  ),
                  borderRadius: BorderRadius.circular(28),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: _image != null 
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.fill,
                    
                  ),
                )
                : Center(
                  child: Icon(
                    Icons.add_photo_alternate,
                    size: 40,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                )
              )
            ),
          ),
          SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: darkModeNotifier,
            builder: (context, value, child) {
              return Form(
                key: _formKey,
                child: TextFormField(
                  controller: _albumNameController,
                  textAlign: TextAlign.center,
                  maxLength: 50,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 30,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                    hintText: "Type album name...",
                    hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 30,
                      color: darkModeNotifier.value ? const Color.fromARGB(22, 194, 192, 192) :const Color.fromARGB(63, 64, 64, 64) ,
                    )
                  ), 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter an album name.";
                    }
                    return null;
                  },
                ),
              );
            }
          ),
          SizedBox(height:20),
          CustomSettingsTiles(
            leading: Text(
              "Choose Mode",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            mainWidget: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedMode,
                    items: modes, 
                    onChanged: (value) {
                      setState(() {
                        selectedMode = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero, 
                    ),
                  ),
                ),
              ],
            ),
          ),
          //fix the color issue with this
          ValueListenableBuilder(
            valueListenable: darkModeNotifier,
            builder: (context, value, child) {
              return AnimatedSwitcher(
                key: ValueKey(selectedMode),
                duration: Duration(milliseconds: 1),
                child: selectedMode != "Single" ?
                CustomSettingsTiles(
                  key: ValueKey(selectedMode),
                  leading: Text(
                    "Add Members",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  mainWidget: Row(
                    children: [
                      
                    ],
                  ),
                  onPressed: () async {
                    final selected = await showModalBottomSheet<List<String>>(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return FractionallySizedBox(
                          heightFactor: 0.85,
                          child: AddMembersSheet(
                            selectedMode: AlbumMode.fromName(selectedMode),
                          ),
                        );
                      },
                    );

                    if (selected != null && mounted) {
                      setState(() {
                        members = selected;
                      });
                    }
                  },
                  trailing: Text("${members.length + 1}/${AlbumMode.fromName(selectedMode).maxPeople}"),
                  color: value ? const Color.fromARGB(63, 64, 64, 64) : const Color.fromARGB(24, 143, 142, 142)
                ) :
                SizedBox(height: 0)
              );
            }
          ),
          CustomSettingsTiles(
            leading: Text(
              "Opening Date",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            mainWidget: TextFormField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.calendar_today,
                  color: const Color.fromARGB(255, 122, 53, 69),
                )
              ),
              onTap: () async {
                await _pickDate();
              }
            ),
          ),
          CustomSettingsTiles(
            title: "Notifications ",
            trailing: Switch(
              activeColor:  const Color.fromARGB(255, 130, 14, 42),
              value: notificationsOn,
              onChanged: (value) {
                setState(() {
                  notificationsOn = value;
                });
              },
            ),
          ),
          SizedBox(height: 30,),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:const Color.fromARGB(255, 130, 14, 42),
              ),
              onPressed: createAlbum, 
              child: Text(
                "Create Album",
                style: TextStyle(
                  color: Colors.white,
                )
              ),
            ),
          ),
        ],
      )
    );
  }

  Future<void> _imageFromGallery() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null){
      try {
        setState(() {
         _image = File(pickedFile.path);
        });
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context, 
      firstDate: DateTime.now(), 
      lastDate: DateTime(2050, 12, 31),
      initialDate: DateTime.now(),
    );

    setState(() {
      selectedDate = pickedDate ?? DateTime.now();
      _dateController.text = dateToString(selectedDate);
    });
  }

  String dateToString(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  AlbumMode stringToAlbumMode(value) {
    switch (value) {
      case "single":
        return AlbumMode.single;
      case "couple":
        return AlbumMode.couple;
      case "friends":
        return AlbumMode.friends;
      case "friends+":
        return AlbumMode.friendsPlus;
      default:
        return AlbumMode.single;
    }
  }

  void createAlbum() async {

    if (_formKey.currentState!.validate()) {
      final String uid = FirebaseService.currentUser!.uid;
        final albumRef = FirebaseFirestore.instance
        .collection("albums")
        .doc();
        final albumId = albumRef.id;
        
        String coverUrl = "";

        if (_image != null) {
          try {
            final coverRef = FirebaseStorage.instance
              .ref()
              .child("albums")
              .child(albumId)
              .child("album_cover");
              await coverRef.putFile(_image!);
              coverUrl = await coverRef.getDownloadURL();
          }
          catch (e) {
            print(e);
          }
        } 
      await albumRef.set({
        "id": albumId,
        "owner": uid,
        "mode": selectedMode,
        "name": _albumNameController.text, 
        "openAt": Timestamp.fromDate(selectedDate),
        "notificationsEnabled": notificationsOn,
        "coverPath": coverUrl,
        "members": [uid, ...members],
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            content: Text("Album is created successfully."), 
            backgroundColor: Theme.of(context).colorScheme.primary
          )
        );
      }

      
      Navigator.of(context).pop();
    }
  }
}