import 'dart:io';
import 'package:back_to_us/Widgets/custom_recording_wave_widget.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class VoiceWidget extends StatefulWidget {
  const VoiceWidget({
    super.key,
    this.onStartRecordingReady,
    this.onStopRecordingReady,
  });

  final Function(Future<void> Function()?)? onStartRecordingReady;
  final Function(Future<File?> Function()?)? onStopRecordingReady;

  @override
  State<VoiceWidget> createState() => _VoiceWidgetState();
}

class _VoiceWidgetState extends State<VoiceWidget> {
  bool isRecording = false;
  late final AudioRecorder _audioRecorder;
  String? _audioPath;

  @override
  void initState() {
    _audioRecorder = AudioRecorder();
    super.initState();

    widget.onStartRecordingReady?.call(_startRecording);
    widget.onStopRecordingReady?.call(_stopRecording);
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return CustomRecordingWaveWidget(isAnimating: isRecording,);
  }

  Future<void> _startRecording() async {
    if (!await _audioRecorder.hasPermission()) {
      debugPrint("Microphone permission not granted.");
      return;
    }

    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _audioRecorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: path,
    );

    setState(() {
      isRecording = true;
      _audioPath = path;
    });

    debugPrint("Recording started → $path");
  }

  Future<File?> _stopRecording() async {
    final path = await _audioRecorder.stop();
    if (path == null) return null;

    setState(() {
      isRecording = false;
      _audioPath = path;
    });

    debugPrint("Recording saved locally: $path");

    return File(path);
  }
}

/*
try {
      await file.delete();
      debugPrint("Deleted temp audio file");
    } catch (e) {
      debugPrint("Failed to delete temp file: $e");
    }

*/