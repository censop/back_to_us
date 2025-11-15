import 'package:back_to_us/Services/notifiers.dart';
import 'package:flutter/material.dart';

class CustomSettingsTiles extends StatelessWidget {
  const CustomSettingsTiles({
    super.key,
    this.onPressed,
    this.title,
    this.mainWidget,
    this.leading,
    this.trailing,
    this.color
  });

  final void Function()? onPressed;
  final String? title;
  final Widget? leading;
  final Widget? trailing;
  final Widget? mainWidget;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.onInverseSurface,
        leading: leading,
        title: title != null ? Text(
          title!,
          style: Theme.of(context).textTheme.bodyLarge,
        ) :
        mainWidget,
        trailing: trailing,
        onTap: onPressed,
      ),
    );
  }
}