import 'dart:async';
import 'package:flutter/material.dart';

class CustomRecordingWaveWidget extends StatefulWidget {
  const CustomRecordingWaveWidget({
    super.key,
    required this.isAnimating,
  });

  final bool isAnimating; // 🔹 New property to control animation state

  @override
  State<CustomRecordingWaveWidget> createState() => _RecordingWaveWidgetState();
}

class _RecordingWaveWidgetState extends State<CustomRecordingWaveWidget> {
  final List<double> _heights = [0.05, 0.07, 0.1, 0.07, 0.05];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateAnimationState();
  }

  @override
  void didUpdateWidget(CustomRecordingWaveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 🔹 Restart or stop animation when property changes
    if (oldWidget.isAnimating != widget.isAnimating) {
      _updateAnimationState();
    }
  }

  void _updateAnimationState() {
    _timer?.cancel();

    if (widget.isAnimating) {
      _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
        setState(() {
          _heights.add(_heights.removeAt(0));
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _heights.map((height) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 20,
            height: MediaQuery.sizeOf(context).height * height,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(50),
            ),
          );
        }).toList(),
      ),
    );
  }
}
