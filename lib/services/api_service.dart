import '../models/song.dart';
import '../models/playlist.dart';
import '../models/podcast.dart';
import '../models/user.dart';
import '../models/post.dart';

class ApiService {
  // 实际项目中替换为真实的API地址
  static const String baseUrl = 'https://api.example.com';

  // 模拟网络延迟
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  // 获取推荐歌单
  Future<List<Playlist>> getRecommendedPlaylists() async {
    await _simulateNetworkDelay();
    // 模拟数据
    return List.generate(
      6,
      (index) => Playlist(
        id: 'playlist_$index',
        title: '推荐歌单 ${index + 1}',
        description: '这是一个推荐歌单',
        coverUrl: 'https://picsum.photos/200',
        creatorId: 'user_1',
        creatorName: '网易云音乐',
        songIds: [],
        playCount: 10000 + index * 1000,
        isOfficial: true,
      ),
    );
  }

  // 获取最新音乐
  Future<List<Song>> getLatestSongs() async {
    await _simulateNetworkDelay();
    return List.generate(
      10,
      (index) => Song(
        id: 'song_$index',
        title: '新歌 ${index + 1}',
        artist: '歌手 ${index + 1}',
        album: '专辑 ${index + 1}',
        coverUrl: 'https://picsum.photos/200',
        audioUrl: 'https://example.com/song_$index.mp3',
        duration: const Duration(minutes: 3, seconds: 30),
      ),
    );
  }

  // 获取推荐播客
  Future<List<Podcast>> getRecommendedPodcasts() async {
    await _simulateNetworkDelay();
    return List.generate(
      6,
      (index) => Podcast(
        id: 'podcast_$index',
        title: '播客 ${index + 1}',
        description: '这是一个播客节目',
        coverUrl: 'https://picsum.photos/200',
        author: '主播 ${index + 1}',
        categories: ['音乐', '谈话'],
        episodes: [],
        subscriberCount: 5000 + index * 500,
      ),
    );
  }

  // 获取社区动态
  Future<List<Post>> getCommunityPosts() async {
    await _simulateNetworkDelay();
    return List.generate(
      10,
      (index) => Post(
        id: 'post_$index',
        userId: 'user_$index',
        username: '用户 ${index + 1}',
        content: '这是第 ${index + 1} 条动态内容...',
        createTime: DateTime.now().subtract(Duration(hours: index)),
        songId: index % 2 == 0 ? 'song_$index' : null,
        songTitle: index % 2 == 0 ? '分享的歌曲 $index' : null,
        songArtist: index % 2 == 0 ? '歌手 $index' : null,
      ),
    );
  }

  // 获取用户信息
  Future<User> getUserProfile(String userId) async {
    await _simulateNetworkDelay();
    return User(
      id: userId,
      username: '测试用户',
      avatarUrl: 'https://picsum.photos/200',
      isVip: true,
      createdPlaylists: [],
      likedPlaylists: [],
    );
  }
}
