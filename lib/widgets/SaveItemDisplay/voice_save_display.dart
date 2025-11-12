import 'dart:io';
import 'package:back_to_us/Services/voice_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class VoiceSaveDisplay extends StatefulWidget {
  const VoiceSaveDisplay({
    super.key,
    required this.file
  });

  final File file;

  @override
  State<VoiceSaveDisplay> createState() => _VoiceSaveDisplayState();
}

class _VoiceSaveDisplayState extends State<VoiceSaveDisplay> {
  late AudioPlayer _player;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    _player.playerStateStream.listen((state) {
      final isCurrentlyPlaying = state.playing;
      final hasCompleted = state.processingState == ProcessingState.completed;

      if (mounted) {
        setState(() {
          isPlaying = isCurrentlyPlaying && !hasCompleted;
        });
      }

      if (hasCompleted) {
        _player.seek(Duration.zero);
      }
    });

    _getDuration();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 40,
      color: Theme.of(context).colorScheme.primary,
      icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
      onPressed: _togglePlay,
    );
  }

  Future<void> _togglePlay() async {
    if (!isPlaying) {
      try {
        await _player.setFilePath(widget.file.path);
        await _player.play();
      } catch (e) {
        debugPrint("Error playing audio: $e");
      }
    } else {
      await _player.stop();
    }
  }

  Future<void> _getDuration() async {
    try {
      await _player.setFilePath(widget.file.path);
      final duration = _player.duration;
      
      if (duration != null) {
        VoiceService.voiceDuration = duration;
        debugPrint("Audio duration: ${duration.inSeconds} seconds");
      }
    } catch (e) {
      debugPrint("Error getting audio duration: $e");
    }
  }

}

