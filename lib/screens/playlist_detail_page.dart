import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/playlist.dart';
import '../models/song.dart';
import '../providers/audio_provider.dart';
import '../providers/music_provider.dart';
import '../screens/player_detail_page.dart';

class PlaylistDetailPage extends StatelessWidget {
  final Playlist playlist;

  const PlaylistDetailPage({
    super.key,
    required this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Consumer<MusicProvider>(
            builder: (context, musicProvider, child) {
              return FutureBuilder<List<Song?>>(
                future: Future.wait(
                  playlist.songIds.map((id) => musicProvider.getSongById(id)),
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final songs = snapshot.data!.whereType<Song>().toList();

                  return CustomScrollView(
                    slivers: [
                      // 顶部歌单信息
                      SliverAppBar(
                        expandedHeight: 200,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          title: Text(playlist.title),
                          background: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                playlist.coverUrl,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 歌单信息
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    child: Text(
                                      playlist.creatorName[0],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(playlist.creatorName),
                                  const Spacer(),
                                  Text(
                                      '${(playlist.playCount / 10000).toStringAsFixed(1)}万'),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                playlist.description,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 歌曲列表
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final song = songs[index];

                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.asset(
                                  song.coverUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(song.title),
                              subtitle: Text(song.artist),
                              trailing: Consumer<AudioProvider>(
                                builder: (context, audioProvider, child) {
                                  final isCurrentSong =
                                      audioProvider.currentSong?.id == song.id;
                                  final isPlaying = audioProvider.isPlaying;

                                  return IconButton(
                                    icon: Icon(
                                      isCurrentSong && isPlaying
                                          ? Icons.pause_circle_outline
                                          : Icons.play_circle_outline,
                                    ),
                                    onPressed: () {
                                      if (isCurrentSong) {
                                        audioProvider.playPause();
                                      } else {
                                        audioProvider.playSong(song);
                                        audioProvider.setPlaylist(
                                          songs,
                                          initialIndex: index,
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            );
                          },
                          childCount: songs.length,
                        ),
                      ),

                      // 底部留白
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 120),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          // 添加 MiniPlayer
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Consumer<AudioProvider>(
              builder: (context, audioProvider, child) {
                final currentSong = audioProvider.currentSong;
                if (currentSong == null) return const SizedBox.shrink();

                final isDarkMode =
                    Theme.of(context).brightness == Brightness.dark;

                return Container(
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
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(currentSong.coverUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlayerDetailPage(),
                        ),
                      );
                    },
                    title: Text(
                      currentSong.title,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      currentSong.artist,
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            audioProvider.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          onPressed: () => audioProvider.playPause(),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.skip_next,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          onPressed: () => audioProvider.nextSong(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
