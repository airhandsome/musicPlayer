import 'package:flutter/foundation.dart';
import '../models/song.dart';
import '../models/playlist.dart';
import '../services/api_service.dart';
import '../services/audio_service.dart';

class MusicProvider with ChangeNotifier {
  final ApiService _apiService;
  final AudioService _audioService;

  MusicProvider({
    required ApiService apiService,
    required AudioService audioService,
  })  : _apiService = apiService,
        _audioService = audioService;

  List<Playlist> _recommendedPlaylists = [];
  List<Song> _latestSongs = [];
  bool _isLoading = false;
  Song? get currentSong => _audioService.currentSong;

  List<Playlist> get recommendedPlaylists => _recommendedPlaylists;
  List<Song> get latestSongs => _latestSongs;
  bool get isLoading => _isLoading;

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final playlists = await _apiService.getRecommendedPlaylists();
      final songs = await _apiService.getLatestSongs();

      _recommendedPlaylists = playlists;
      _latestSongs = songs;
      // ignore: empty_catches
    } catch (e) {}

    _isLoading = false;
    notifyListeners();
  }

  Future<void> playSong(Song song) async {
    await _audioService.playSong(song);
    notifyListeners();
  }

  Future<void> pauseSong() async {
    await _audioService.pause();
    notifyListeners();
  }

  Future<void> resumeSong() async {
    await _audioService.resume();
    notifyListeners();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
