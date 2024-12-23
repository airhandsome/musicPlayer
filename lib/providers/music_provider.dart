import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/playlist.dart';
import '../models/song.dart';
import '../services/api_service.dart';
import '../services/audio_service.dart';
import '../services/local_music_service.dart';

class MusicProvider with ChangeNotifier {
  final ApiService apiService;
  final AudioService audioService;
  List<Playlist> _recommendedPlaylists = [];
  List<Song> _latestSongs = [];
  bool _isLoading = true;
  final List<Playlist> _userPlaylists = [];

  MusicProvider({
    required this.apiService,
    required this.audioService,
  });

  List<Playlist> get recommendedPlaylists => _recommendedPlaylists;
  List<Song> get latestSongs => _latestSongs;
  bool get isLoading => _isLoading;
  List<Playlist> get userPlaylists => _userPlaylists;

  Future<void> loadInitialData() async {
    try {
      _isLoading = true;
      notifyListeners();

      // 模拟网络延迟
      await Future.delayed(const Duration(milliseconds: 800));

      // 加载推荐歌单
      final playlistsJson =
          await rootBundle.loadString('assets/data/recommended_playlists.json');
      final playlistsData = json.decode(playlistsJson);
      _recommendedPlaylists = (playlistsData['playlists'] as List)
          .map((json) => Playlist.fromJson(json))
          .toList();

      // 加载最新音乐
      final songsJson =
          await rootBundle.loadString('assets/data/latest_songs.json');
      final songsData = json.decode(songsJson);
      _latestSongs = (songsData['songs'] as List)
          .map((json) => Song.fromJson(json))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading data: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // 获取歌单详情
  Future<Playlist?> getPlaylistById(String id) async {
    try {
      return _recommendedPlaylists.firstWhere((playlist) => playlist.id == id);
    } catch (e) {
      print('Error getting playlist: $e');
      return null;
    }
  }

  // 获取歌曲详情
  Future<Song?> getSongById(String id) async {
    try {
      return _latestSongs.firstWhere((song) => song.id == id);
    } catch (e) {
      print('Error getting song: $e');
      return null;
    }
  }

  // 创建新播放列表
  Future<void> createPlaylist(String name) async {
    final newPlaylist = Playlist(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: name,
      coverUrl: 'assets/images/playlist_default.jpg', // 默认封面
      description: '',
      songIds: [],
      playCount: 0,
      creatorId: 'current_user',
      creatorName: '我的歌单',
      isOfficial: false,
    );

    _userPlaylists.add(newPlaylist);
    notifyListeners();
    // TODO: 保存到本地存储
  }

  // 添加歌曲到播放列表
  Future<void> addSongToPlaylist(Song song, Playlist playlist) async {
    final index = _userPlaylists.indexWhere((p) => p.id == playlist.id);
    if (index != -1) {
      // 检查歌曲是否已经在播放列表中
      if (!_userPlaylists[index].songIds.contains(song.toString())) {
        _userPlaylists[index].songIds.add(song.toString());
        notifyListeners();
        // TODO: 保存到本地存储
      }
    }
  }

  Future<void> importLocalMusic(
    void Function(double progress, String message) onProgress,
  ) async {
    final localMusicService = LocalMusicService();
    final result = await localMusicService.importLocalMusic(onProgress);

    if (result != null) {
      final (playlist, songs) = result;
      _recommendedPlaylists.add(playlist);
      // 将歌曲添加到本地音乐库
      _latestSongs.addAll(songs);
      notifyListeners();
    }
  }
}
