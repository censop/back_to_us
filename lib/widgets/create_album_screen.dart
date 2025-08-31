
import 'package:back_to_us/Services/notifiers.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:back_to_us/Widgets/custom_settings_tiles.dart';
import 'package:back_to_us/routes.dart';
import 'package:flutter/material.dart';


class CreateAlbumScreen extends StatefulWidget {
  const CreateAlbumScreen({super.key});

  @override
  State<CreateAlbumScreen> createState() => _CreateAlbumScreenState();
}

class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
  /*File? _image;
  final ImagePicker _imagePicker = ImagePicker();
  final ref = FirebaseStorage.instance.ref().child("album_covers").child(FirebaseService.currentUser!.uid);*/

  String? selectedMode = "single";
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
      value: "single",
      child: Text("Single", overflow: TextOverflow.ellipsis,)
    ),
    DropdownMenuItem(
      value: "couple",
      child: Text("Couple", overflow: TextOverflow.ellipsis)
    ),
    DropdownMenuItem(
      value: "friends",
      child: Text("Friends", overflow: TextOverflow.ellipsis)
    ),
    DropdownMenuItem(
      value: "friends+",
      child: Text("Friends+", overflow: TextOverflow.ellipsis)
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          "Create an Album",
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
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
              onTap: () {
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 5
                  ),
                  borderRadius: BorderRadius.circular(28),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Center(
                  child: Icon(
                    Icons.add_photo_alternate,
                    size: 40
                  ),
                )
              ),
            ),
          ),
          SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: darkModeNotifier,
            builder: (context, value, child) {
              return TextFormField(
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
                      //to be filled
                      setState(() {
                        selectedMode = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none, // removes default underline
                      contentPadding: EdgeInsets.zero, // aligns better
                    ),
                  ),
                ),
              ],
            ),
          ),
          //add members if it is not solo
          /*AnimatedSwitcher(
            duration: Duration(milliseconds: 1),
            child: selectedMode != "single" ?
            CustomSettingsTiles(
              title: "Add Members",
              onPressed: () {},
            ) :
            SizedBox(height: 0)
          ) */
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
          ElevatedButton(
            onPressed: () {}, 
            child: Text("Create Album"),
          ),

        ],
      )
    );
  }

/*
  void _addAlbumCover() {

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
  } */
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
}