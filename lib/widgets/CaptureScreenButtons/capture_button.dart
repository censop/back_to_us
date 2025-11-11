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
  bool _isProcessing = false;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTapDown,
      onTapUp: widget.onTapUp,
      onTapCancel: widget.onTapCancel,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.circle,
            color: const Color.fromARGB(118, 255, 255, 255),
            size: 70
          ),
          Icon(
            Icons.circle,
            color: widget.innerCircleColor,
            size: 60
          ),
        ],
      ),
    );
  }
}