import 'package:flutter/material.dart';
import '../models/song.dart';

class MiniPlayer extends StatelessWidget {
  final Song? currentSong;
  final bool isPlaying;
  final VoidCallback? onPlayPause;
  final VoidCallback? onNext;
  final VoidCallback? onTap;

  const MiniPlayer({
    super.key,
    this.currentSong,
    this.isPlaying = false,
    this.onPlayPause,
    this.onNext,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (currentSong == null) return const SizedBox.shrink();

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            // 封面 - 添加动画效果
            Hero(
              tag: 'album-cover',
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    // 使用二次元风格的默认封面
                    image: NetworkImage(
                      'https://example.com/anime-default-cover.jpg', // 替换为实际的默认封面
                    ),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            // 歌曲信息
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentSong!.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentSong!.artist,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // 控制按钮
            IconButton(
              icon: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Theme.of(context).primaryColor,
                size: 32,
              ),
              onPressed: onPlayPause,
            ),
            IconButton(
              icon: Icon(
                Icons.skip_next_rounded,
                size: 32,
                color: isDarkMode ? Colors.white70 : Colors.grey[800],
              ),
              onPressed: onNext,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
