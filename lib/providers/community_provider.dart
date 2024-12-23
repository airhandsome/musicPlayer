import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/post.dart';

class CommunityProvider with ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPosts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // 模拟网络延迟
      await Future.delayed(const Duration(seconds: 1));

      final String jsonData =
          await rootBundle.loadString('assets/data/community_posts.json');
      final data = json.decode(jsonData);

      _posts =
          (data['posts'] as List).map((json) => Post.fromJson(json)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = '加载失败：$e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(String postId) async {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index == -1) return;

    // 模拟网络请求
    await Future.delayed(const Duration(milliseconds: 500));

    final post = _posts[index];
    final updatedPost = Post(
      id: post.id,
      userId: post.userId,
      userName: post.userName,
      userAvatar: post.userAvatar,
      content: post.content,
      images: post.images,
      createTime: post.createTime,
      likeCount: post.isLiked ? post.likeCount - 1 : post.likeCount + 1,
      commentCount: post.commentCount,
      isLiked: !post.isLiked,
    );

    _posts[index] = updatedPost;
    notifyListeners();
  }
}
