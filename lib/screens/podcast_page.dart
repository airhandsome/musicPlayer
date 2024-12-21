import 'package:flutter/material.dart';

class PodcastPage extends StatelessWidget {
  const PodcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 推荐播客标题
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '推荐播客',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // 推荐播客网格
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildPodcastItem(),
              childCount: 6,
            ),
          ),
        ),

        // 热门���类
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '热门分类',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // 分类列表
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildCategoryItem(),
            childCount: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildPodcastItem() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: const Center(child: Icon(Icons.mic)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '播客标题',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem() {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.category),
      ),
      title: const Text('分类名称'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
