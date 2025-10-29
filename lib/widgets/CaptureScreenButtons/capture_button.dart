import 'package:flutter/material.dart';

class CaptureButton extends StatefulWidget {
  const CaptureButton({
    super.key,
    this.onTap,
    this.onTapCancel,
    this.onTapDown,
    this.onTapUp,
    required this.innerCircleColor,
  });

  final void Function()? onTap;
  final void Function(TapDownDetails)? onTapDown;
  final void Function(TapUpDetails)? onTapUp;
  final void Function()? onTapCancel;
  final Color innerCircleColor;

  @override
  State<CaptureButton> createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<CaptureButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: widget.onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.circle,
                color: Theme.of(context).colorScheme.primary,
                size: 70
              ),
              Icon(
                Icons.circle,
                color: Theme.of(context).colorScheme.surface,
                size: 60
              ),
              Icon(
                Icons.circle,
                color: widget.innerCircleColor,
                size: 55
              ),
            ],
          ),
        );
  }
}