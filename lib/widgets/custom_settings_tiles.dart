import 'package:flutter/material.dart';

class CustomSettingsTiles extends StatelessWidget {
  const CustomSettingsTiles({
    super.key,
    required this.onPressed,
    required this.title,
    this.leading,
    this.trailing,
  });

  final void Function()? onPressed;
  final String title;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Colors.black
        ),
      ),
      trailing: trailing,
      onTap: onPressed,
    );
  }
}