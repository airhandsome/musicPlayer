import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../models/playlist.dart';
import '../models/song.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<MusicProvider>().loadInitialData(),
    );
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
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('轮播图区域'),
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
                    return _buildPlaylistItem(playlist);
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

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= musicProvider.latestSongs.length) {
                      return null;
                    }
                    final song = musicProvider.latestSongs[index];
                    return _buildMusicListItem(song, musicProvider);
                  },
                ),
              ),
            ),

            // 底部留白
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
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

  Widget _buildPlaylistItem(Playlist playlist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(playlist.coverUrl),
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
      ],
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
              onPressed: () => musicProvider.playSong(song),
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
}
