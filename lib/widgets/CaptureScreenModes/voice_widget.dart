import 'dart:io';

import 'package:back_to_us/Services/camera_service.dart';
import 'package:back_to_us/Widgets/custom_recording_wave_widget.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

class VoiceWidget extends StatefulWidget {
  const VoiceWidget({super.key});

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
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomRecordingWaveWidget(),
    );
  }

  Future<void> _startRecording() async {
    if (!await _audioRecorder.hasPermission()) {
      debugPrint("❌ Microphone permission not granted.");
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

    debugPrint("🎙️ Recording started → $path");
  }

  Future<void> _stopRecording() async {
    final path = await _audioRecorder.stop();
    if (path == null) return;

    setState(() {
      isRecording = false;
      _audioPath = path;
    });

    debugPrint("✅ Recording saved locally: $path");

    final file = File(path);
    

    // optional cleanup
    try {
      await file.delete();
      debugPrint("🧹 Deleted temp audio file");
    } catch (e) {
      debugPrint("⚠️ Failed to delete temp file: $e");
    }
  }
  
  Future getTemporaryDirectory() async {}
}