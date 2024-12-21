import 'package:flutter/foundation.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class CommunityProvider with ChangeNotifier {
  final ApiService _apiService;

  CommunityProvider({required ApiService apiService})
      : _apiService = apiService;

  List<Post> _posts = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> loadPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _posts = await _apiService.getCommunityPosts();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading posts: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> likePost(String postId) async {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      _posts[postIndex] = Post(
        id: post.id,
        userId: post.userId,
        username: post.username,
        content: post.content,
        createTime: post.createTime,
        likeCount: post.isLiked ? post.likeCount - 1 : post.likeCount + 1,
        isLiked: !post.isLiked,
      );
      notifyListeners();
    }
  }
}
