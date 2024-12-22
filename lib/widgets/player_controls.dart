import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        final song = audioProvider.currentSong;
        if (song == null) return const SizedBox.shrink();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 进度条
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamBuilder<Duration>(
                stream: audioProvider.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration = audioProvider.duration;

                  return Column(
                    children: [
                      Slider(
                        value: position.inSeconds.toDouble(),
                        max: duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          audioProvider.seek(Duration(seconds: value.toInt()));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(position)),
                            Text(_formatDuration(duration)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // 控制按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 32),
                  onPressed: audioProvider.previousSong,
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: Icon(
                    audioProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 48,
                  ),
                  onPressed: audioProvider.playPause,
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 32),
                  onPressed: audioProvider.nextSong,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
