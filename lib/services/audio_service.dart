import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? _currentSong;

  Song? get currentSong => _currentSong;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  Future<void> playSong(Song song) async {
    if (_currentSong?.id != song.id) {
      _currentSong = song;
      await _audioPlayer.setUrl(song.audioUrl);
    }
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.play();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentSong = null;
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
