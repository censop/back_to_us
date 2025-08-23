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