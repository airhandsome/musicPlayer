import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? _currentSong;
  List<Song> _playlist = [];
  int _currentIndex = -1;

  AudioProvider() {
    // 监听播放状态变化
    _audioPlayer.playerStateStream.listen((state) {
      notifyListeners();
    });

    // 监听播放位置变化
    _audioPlayer.positionStream.listen((position) {
      notifyListeners();
    });
  }

  // Getters
  AudioPlayer get audioPlayer => _audioPlayer;
  Song? get currentSong => _currentSong;
  bool get isPlaying => _audioPlayer.playing;
  Duration get position => _audioPlayer.position;
  Duration get duration => _audioPlayer.duration ?? Duration.zero;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  // 播放控制方法
  Future<void> playSong(Song song) async {
    try {
      _currentSong = song;
      await _audioPlayer.setAsset(song.audioUrl);
      await _audioPlayer.play();
      notifyListeners();
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  Future<void> playPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> setPlaylist(List<Song> songs, {int initialIndex = 0}) async {
    _playlist = songs;
    _currentIndex = initialIndex;
    if (songs.isNotEmpty) {
      await playSong(songs[initialIndex]);
    }
  }

  Future<void> nextSong() async {
    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
      await playSong(_playlist[_currentIndex]);
    }
  }

  Future<void> previousSong() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      await playSong(_playlist[_currentIndex]);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
