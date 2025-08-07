import 'package:back_to_us/Services/firebase_service.dart';
import 'package:flutter/material.dart';

class CustomProfilePictureDisplayer extends StatefulWidget {
  const CustomProfilePictureDisplayer({
    super.key,
    required this.radius,
    this.imageUrl,
    this.onPressed,
  });

  final String? imageUrl;
  final void Function()? onPressed;
  final double radius;

  @override
  State<CustomProfilePictureDisplayer> createState() => _CustomProfilePictureDisplayerState();
}

class _CustomProfilePictureDisplayerState extends State<CustomProfilePictureDisplayer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: CircleAvatar(
        backgroundColor: const Color.fromARGB(255, 206, 203, 203),
        backgroundImage: widget.imageUrl == null ? null : NetworkImage(widget.imageUrl!),
        radius: widget.radius,
        child: widget.imageUrl == null 
        ? (
            FirebaseService.currentUser != null
            ? Text(
                FirebaseService.currentUser!.username[0].toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: widget.radius,
                      color: const Color.fromARGB(255, 243, 241, 241),
                    ),
              )
            : const Icon(Icons.person, color: const Color.fromARGB(255, 243, 241, 241),
            )
        )
        : null,
      ),
    );
  }
}
