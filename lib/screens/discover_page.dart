import 'package:flutter/material.dart';
import 'package:musicplayer/providers/audio_provider.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../models/playlist.dart';
import '../models/song.dart';
import 'dart:async';
import 'playlist_detail_page.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
    Future.microtask(
      () => context.read<MusicProvider>().loadInitialData(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, musicProvider, child) {
        if (musicProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            // 轮播图区域
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                margin: const EdgeInsets.all(16),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      children: [
                        _buildBannerImage('assets/images/banners/banner1.jpg'),
                        _buildBannerImage('assets/images/banners/banner2.jpg'),
                        _buildBannerImage('assets/images/banners/banner3.jpg'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 图标导航菜单
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildIconButton(Icons.calendar_today, '每日推荐'),
                    _buildIconButton(Icons.library_music, '歌单'),
                    _buildIconButton(Icons.show_chart, '排行榜'),
                    _buildIconButton(Icons.radio, '电台'),
                    _buildIconButton(Icons.live_tv, '直播'),
                  ],
                ),
              ),
            ),

            // 推荐歌单
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '推荐歌单',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // 推荐歌单网格
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final playlist = musicProvider.recommendedPlaylists[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaylistDetailPage(
                              playlist: playlist,
                            ),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: AssetImage(playlist.coverUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            playlist.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            '${(playlist.playCount / 10000).toStringAsFixed(1)}万',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: musicProvider.recommendedPlaylists.length,
                ),
              ),
            ),

            // 最新音乐部分
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  '最新音乐',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // 最新音乐列表
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final song = musicProvider.latestSongs[index];
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
                                musicProvider.latestSongs,
                                initialIndex: index,
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                },
                childCount: musicProvider.latestSongs.length,
              ),
            ),

            // 底部留白
            const SliverToBoxAdapter(
              child: SizedBox(height: 120), // 为底部播放器和导航栏留出空间
            ),
          ],
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.red[50],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.red),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildPlaylistItem(BuildContext context, Playlist playlist) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaylistDetailPage(
              playlist: playlist,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(playlist.coverUrl),
                  fit: BoxFit.cover,
                ),
                // 添加占位颜色，便于调试
                color: Colors.grey[200],
              ),
              // 添加错误处理
              child: Stack(
                children: [
                  if (playlist.coverUrl.isEmpty)
                    const Center(
                      child: Icon(Icons.music_note, size: 40),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            playlist.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            '${(playlist.playCount / 10000).toStringAsFixed(1)}万',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicListItem(Song song, MusicProvider musicProvider) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            song.coverUrl,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 56,
                height: 56,
                color: Colors.grey[300],
                child: const Icon(Icons.music_note),
              );
            },
          ),
        ),
        title: Text(
          song.title,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          song.artist,
          style: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.play_circle_outline,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                final audioProvider = context.read<AudioProvider>();
                audioProvider.playSong(song);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: isDarkMode ? Colors.white70 : Colors.grey[700],
              ),
              onPressed: () {
                // TODO: 显示更多选项菜单
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerImage(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
