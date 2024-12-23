import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/post.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import '../providers/community_provider.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<CommunityProvider>().loadPosts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(provider.error!),
                ElevatedButton(
                  onPressed: provider.loadPosts,
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: provider.loadPosts,
          child: ListView.builder(
            itemCount: provider.posts.length + 1,
            itemBuilder: (context, index) {
              if (index == provider.posts.length) {
                return const SizedBox(height: 80);
              }
              final post = provider.posts[index];
              return _PostCard(post: post);
            },
          ),
        );
      },
    );
  }
}

class _PostCard extends StatelessWidget {
  final Post post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(post.userAvatar),
            ),
            title: Text(post.userName),
            subtitle: Text(timeago.format(post.createTime, locale: 'zh')),
            trailing: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {
                // TODO: 显示更多选项
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(post.content),
          ),
          if (post.images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildImageGrid(post.images),
            ),
          const Divider(height: 1),
          Row(
            children: [
              _buildActionButton(
                icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                label: '${post.likeCount}',
                onPressed: () {
                  context.read<CommunityProvider>().toggleLike(post.id);
                },
              ),
              _buildActionButton(
                icon: Icons.comment_outlined,
                label: '${post.commentCount}',
                onPressed: () {
                  // TODO: 实现评论功能
                },
              ),
              _buildActionButton(
                icon: Icons.share_outlined,
                label: '分享',
                onPressed: () {
                  // TODO: 实现分享功能
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(List<String> images) {
    if (images.length == 1) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.asset(
          images[0],
          fit: BoxFit.cover,
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: images
          .map((image) => Image.asset(
                image,
                fit: BoxFit.cover,
              ))
          .toList(),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
