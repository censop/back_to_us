import 'package:back_to_us/Services/firebase_service.dart';
import 'package:flutter/material.dart';

class CustomProfilePictureDisplayer extends StatefulWidget {
  const CustomProfilePictureDisplayer({
    super.key,
    required this.radius,
    this.onPressed,
  });

  final void Function()? onPressed;
  final double radius;

  @override
  State<CustomProfilePictureDisplayer> createState() => _CustomProfilePictureDisplayerState();
}

class _CustomProfilePictureDisplayerState extends State<CustomProfilePictureDisplayer> {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseService.profilePicStream(),
      builder: (context, asyncSnapshot) {
        return InkWell(
          onTap: widget.onPressed,
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 206, 203, 203),
            backgroundImage: asyncSnapshot.data == null || asyncSnapshot.data == ""
             ? null : NetworkImage(asyncSnapshot.data!),
            radius: widget.radius,
            child: asyncSnapshot.data == null || asyncSnapshot.data == ""
            ? (
                const Icon(Icons.person, color: const Color.fromARGB(255, 243, 241, 241),
              )
            )
            : null,
          ),
        );
      }
    );
  }
}
