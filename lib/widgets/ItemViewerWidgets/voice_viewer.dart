import 'package:back_to_us/Models/album_item.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class VoiceViewer extends StatefulWidget {
  const VoiceViewer({
    super.key,
    required this.item,
  });

  final AlbumItem item;

  @override
  State<VoiceViewer> createState() => _VoiceViewerState();
}

class _VoiceViewerState extends State<VoiceViewer> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.setUrl(widget.item.downloadUrl);
  }

  @override
  void dispose() {
    _player.dispose;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          StreamBuilder<PlayerState>(
            stream: _player.playerStateStream, 
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing ?? false;

              if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                return const CircularProgressIndicator();
              } else if (playing != true) {
                return IconButton(
                  icon: const Icon(Icons.play_arrow, size: 40),
                  onPressed: _player.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: const Icon(Icons.pause, size: 40),
                  onPressed: _player.pause,
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.replay, size: 40),
                  onPressed: () => _player.seek(Duration.zero),
                );
              }
            },
          ),
          StreamBuilder<Duration?>(
            stream: _player.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = _player.duration ?? widget.item.duration ?? Duration.zero;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: LinearProgressIndicator(
                  value: duration.inMilliseconds > 0 
                      ? position.inMilliseconds / duration.inMilliseconds
                      : 0.0,
                ),
              );
            },
          ),   
          Text(
            widget.item.duration != null 
                ? "Duration: ${widget.item.duration!.inSeconds}s" 
                : "Loading...",
          ),
        ],
      ),
    );
  }
}