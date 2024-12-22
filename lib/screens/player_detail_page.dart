import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../models/song.dart';

class PlayerDetailPage extends StatelessWidget {
  const PlayerDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        final song = audioProvider.currentSong;
        if (song == null) return const SizedBox.shrink();

        return Scaffold(
          backgroundColor: Colors.black87,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              children: [
                Text(
                  song.title,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  song.artist,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              const Spacer(),
              // 唱片旋转动画
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[800]!, width: 20),
                ),
                child: ClipOval(
                  child: Image.asset(
                    song.coverUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Spacer(),
              // 进度条
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    StreamBuilder<Duration>(
                      stream: audioProvider.positionStream,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        final duration = audioProvider.duration;

                        return Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: Colors.grey[800],
                                thumbColor: Colors.white,
                                trackHeight: 2.0,
                              ),
                              child: Slider(
                                value: position.inSeconds.toDouble(),
                                max: duration.inSeconds.toDouble(),
                                onChanged: (value) {
                                  audioProvider.seek(
                                    Duration(seconds: value.toInt()),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(position),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    _formatDuration(duration),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              // 控制按钮
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.shuffle,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // TODO: 实现随机播放
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                        size: 36,
                      ),
                      onPressed: () => audioProvider.previousSong(),
                    ),
                    IconButton(
                      icon: Icon(
                        audioProvider.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        color: Colors.white,
                        size: 64,
                      ),
                      onPressed: () => audioProvider.playPause(),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.skip_next,
                        color: Colors.white,
                        size: 36,
                      ),
                      onPressed: () => audioProvider.nextSong(),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.repeat,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // TODO: 实现循环播放
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
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
