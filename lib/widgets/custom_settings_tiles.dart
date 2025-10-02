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
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
      child: ListTile(
        tileColor: color ?? (darkModeNotifier.value ? const Color.fromARGB(63, 64, 64, 64) : const Color.fromARGB(24, 143, 142, 142)),
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