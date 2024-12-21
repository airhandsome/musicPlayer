import 'package:flutter/material.dart';

class MyMusicPage extends StatelessWidget {
  const MyMusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 用户信息
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '用户名',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('VIP会员'),
                  ],
                ),
              ],
            ),
          ),
        ),

        // 音乐服务
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '音乐服务',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildServiceItem(Icons.cloud_download, '本地/下载'),
                    _buildServiceItem(Icons.history, '最近播放'),
                    _buildServiceItem(Icons.favorite, '我的收藏'),
                    _buildServiceItem(Icons.playlist_play, '我的电台'),
                  ],
                ),
              ],
            ),
          ),
        ),

        // 创建的歌单
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '创建的歌单',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // 歌单列表
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildPlaylistItem(),
            childCount: 5,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceItem(IconData icon, String label) {
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

  Widget _buildPlaylistItem() {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.music_note),
      ),
      title: const Text('我喜欢的音乐'),
      subtitle: const Text('100首'),
      trailing: const Icon(Icons.more_vert),
    );
  }
}
