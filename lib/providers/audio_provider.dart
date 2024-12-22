import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import 'dart:math';

class AudioProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? _currentSong;
  List<Song> _playlist = [];
  int _currentIndex = -1;
  PlayMode _playMode = PlayMode.sequence;
  AudioQuality _quality = AudioQuality.standard;

  AudioProvider() {
    // 监听播放状态变化
    _audioPlayer.playerStateStream.listen((state) {
      notifyListeners();
    });

    // 监听播放位置变化
    _audioPlayer.positionStream.listen((position) {
      notifyListeners();
    });

    _setupPlaybackComplete();
  }

  // Getters
  AudioPlayer get audioPlayer => _audioPlayer;
  Song? get currentSong => _currentSong;
  bool get isPlaying => _audioPlayer.playing;
  Duration get position => _audioPlayer.position;
  Duration get duration => _audioPlayer.duration ?? Duration.zero;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  bool get hasNext => _currentIndex < _playlist.length - 1;
  bool get hasPrevious => _currentIndex > 0;
  PlayMode get playMode => _playMode;
  AudioQuality get quality => _quality;

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
    if (_playlist.isEmpty) return;

    switch (_playMode) {
      case PlayMode.sequence:
        if (_currentIndex < _playlist.length - 1) {
          _currentIndex++;
          await playSong(_playlist[_currentIndex]);
        }
        break;
      case PlayMode.loop:
        _currentIndex = (_currentIndex + 1) % _playlist.length;
        await playSong(_playlist[_currentIndex]);
        break;
      case PlayMode.single:
        await _audioPlayer.seek(Duration.zero);
        await _audioPlayer.play();
        break;
      case PlayMode.random:
        final random = Random();
        _currentIndex = random.nextInt(_playlist.length);
        await playSong(_playlist[_currentIndex]);
        break;
    }
  }

  Future<void> previousSong() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      await playSong(_playlist[_currentIndex]);
    }
  }

  void togglePlayMode() {
    switch (_playMode) {
      case PlayMode.sequence:
        _playMode = PlayMode.loop;
        break;
      case PlayMode.loop:
        _playMode = PlayMode.single;
        break;
      case PlayMode.single:
        _playMode = PlayMode.random;
        break;
      case PlayMode.random:
        _playMode = PlayMode.sequence;
        break;
    }
    notifyListeners();
  }

  void setQuality(AudioQuality quality) async {
    if (_quality == quality) return;

    _quality = quality;

    // 如果当前有正在播放的歌曲，需要重新加载
    if (_currentSong != null) {
      final wasPlaying = isPlaying;
      final position = _audioPlayer.position;

      try {
        // 根据音质获取对应的音频URL
        final audioUrl = _getAudioUrlForQuality(_currentSong!, quality);

        // 重新加载音频
        await _audioPlayer.setAsset(audioUrl);

        // 恢复播放进度
        await _audioPlayer.seek(position);

        // 如果之前在播放，则继续播放
        if (wasPlaying) {
          await _audioPlayer.play();
        }
      } catch (e) {
        print('Error switching audio quality: $e');
      }
    }

    notifyListeners();
  }

  String _getAudioUrlForQuality(Song song, AudioQuality quality) {
    // 这里根据音质返回不同质量的音频文件路径
    // 实际应用中，你可能需要根据后端API或本地文件命名规则来构建URL
    final basePath = song.audioUrl.replaceAll('.mp3', '');

    switch (quality) {
      case AudioQuality.low:
        return '${basePath}_128k.mp3';
      case AudioQuality.standard:
        return '${basePath}_192k.mp3';
      case AudioQuality.high:
        return '${basePath}_320k.mp3';
      case AudioQuality.hifi:
        return '${basePath}.flac';
    }
  }

  void _setupPlaybackComplete() {
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        nextSong();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

enum PlayMode {
  sequence, // 顺序播放
  loop, // 列表循环
  single, // 单曲循环
  random, // 随机播放
}

enum AudioQuality {
  low, // 流畅 (128kbps)
  standard, // 标准 (192kbps)
  high, // 高品质 (320kbps)
  hifi, // 无损 (FLAC)
}

extension AudioQualityExtension on AudioQuality {
  String get label {
    switch (this) {
      case AudioQuality.low:
        return '流畅';
      case AudioQuality.standard:
        return '标准';
      case AudioQuality.high:
        return '高品质';
      case AudioQuality.hifi:
        return '无损';
    }
  }

  String get description {
    switch (this) {
      case AudioQuality.low:
        return '128kbps (省流模式)';
      case AudioQuality.standard:
        return '192kbps';
      case AudioQuality.high:
        return '320kbps';
      case AudioQuality.hifi:
        return 'FLAC无损';
    }
  }
}
