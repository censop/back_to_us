import 'package:flutter/material.dart';


SnackBar customSnackbar({required content, required backgroundColor,}) {
  return SnackBar(
      content: content,
      backgroundColor: backgroundColor,
      elevation: 3,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
}

/*class CustomSnackbar extends StatelessWidget {
  const CustomSnackbar({
    super.key,
    required this.context,
    required this.content,
    required this.backgroundColor,
  });

  final BuildContext context;
  final dynamic content;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: content,
      backgroundColor: backgroundColor,
      elevation: 3,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
} */

