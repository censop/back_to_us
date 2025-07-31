import 'package:flutter/material.dart';

class CustomSettingsTiles extends StatelessWidget {
  const CustomSettingsTiles({
    super.key,
    required this.onPressed,
    required this.title,
    required this.leading,
  });

  final void Function()? onPressed;
  final String title;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 20,
      ),
      onTap: onPressed,
    );
  }
}