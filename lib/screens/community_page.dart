import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 动态发布区域
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  child: Icon(Icons.person),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text('分享你的音乐动态...'),
                ),
                Icon(Icons.image),
              ],
            ),
          ),
        ),

        // 动态列表
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildPostItem(),
            childCount: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildPostItem() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 用户信息
            const Row(
              children: [
                CircleAvatar(
                  child: Icon(Icons.person),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('用户名称',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('2小时前', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                Icon(Icons.more_horiz),
              ],
            ),
            const SizedBox(height: 12),

            // 动态内容
            const Text('这是一条音乐动态分享...'),
            const SizedBox(height: 12),

            // 音乐卡片
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.music_note),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('歌曲名称'),
                        Text('歌手名称', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Icon(Icons.play_circle_outline),
                ],
              ),
            ),

            // 互动按钮
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.thumb_up_outlined, '点赞'),
                _buildActionButton(Icons.comment_outlined, '评论'),
                _buildActionButton(Icons.share_outlined, '分享'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
