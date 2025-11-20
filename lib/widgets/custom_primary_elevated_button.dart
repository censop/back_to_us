import 'package:back_to_us/Theme/my_app_theme.dart';
import 'package:flutter/material.dart';

class CustomPrimaryElevatedButton extends StatefulWidget {
  const CustomPrimaryElevatedButton({
    super.key,
    required this.onPressed,
    required this.child
  });

  final Function()? onPressed;
  final Widget? child;


  @override
  State<CustomPrimaryElevatedButton> createState() => _CustomPrimaryElevatedButtonState();
}

class _CustomPrimaryElevatedButtonState extends State<CustomPrimaryElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyAppTheme.mainColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary
        
      ),
      child: widget.child,
    );
  }
}