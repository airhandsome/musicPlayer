import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:musicplayer/models/playlist.dart';
import 'package:musicplayer/models/song.dart';
import 'package:path/path.dart' as path;
import 'package:audiotagger/audiotagger.dart';
import 'package:path_provider/path_provider.dart';

class LocalMusicService {
  final tagger = Audiotagger();

  Future<(Playlist, List<Song>)?> importLocalMusic(
    void Function(double progress, String message) onProgress,
  ) async {
    try {
      onProgress(0.0, '选择文件夹...');
      String? directoryPath = await FilePicker.platform.getDirectoryPath();

      if (directoryPath == null) return null;

      // 获取音乐文件
      onProgress(0.1, '扫描音乐文件...');
      final dir = Directory(directoryPath);
      final List<FileSystemEntity> files = dir.listSync(recursive: true);
      final musicFiles = files.where((file) {
        final ext = path.extension(file.path).toLowerCase();
        return ['.mp3', '.m4a', '.wav'].contains(ext);
      }).toList();

      if (musicFiles.isEmpty) return null;

      // 创建歌单
      final playlist = Playlist(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        title: path.basename(directoryPath),
        description: '从本地文件夹导入的音乐',
        coverUrl: 'assets/images/covers/local_music.png',
        creatorId: 'local',
        creatorName: '本地音乐',
        songIds: [],
        playCount: 0,
        isOfficial: false,
      );

      // 读取音乐文件信息
      final songs = <Song>[];
      for (int i = 0; i < musicFiles.length; i++) {
        final file = musicFiles[i];
        final progress = 0.1 + (0.9 * i / musicFiles.length);
        onProgress(progress, '正在读取: ${path.basename(file.path)}');

        try {
          final tag = await tagger.readTags(path: file.path);
          final fileName = path.basenameWithoutExtension(file.path);

          songs.add(Song(
            id: 'local_${file.path.hashCode}',
            title: tag?.title ?? fileName,
            artist: tag?.artist ?? '未知艺术家',
            album: tag?.album ?? '未知专辑',
            coverUrl: 'assets/images/covers/default_cover.png',
            audioUrl: file.path,
            duration: const Duration(seconds: 0),
          ));

          // 读取封面
          if (playlist.coverUrl == 'assets/images/covers/local_music.png') {
            final artwork = await tagger.readArtwork(path: file.path);
            if (artwork != null) {
              final coverPath = await _saveCoverImage(artwork, playlist.id);
              playlist.coverUrl = coverPath;
            }
          }
        } catch (e) {
          // 发生错误时使用基本信息添加歌曲
          final fileName = path.basenameWithoutExtension(file.path);
          songs.add(Song(
            id: 'local_${file.path.hashCode}',
            title: fileName,
            artist: '未知艺术家',
            album: '未知专辑',
            coverUrl: 'assets/images/covers/default_cover.png',
            audioUrl: file.path,
            duration: const Duration(milliseconds: 0),
          ));
          print('Error reading metadata for ${file.path}: $e');
          continue;
        }
      }

      onProgress(1.0, '导入完成');
      return (playlist, songs);
    } catch (e) {
      print('Error importing local music: $e');
      return null;
    }
  }

  Future<String> _saveCoverImage(List<int> artwork, String playlistId) async {
    final appDir = await getApplicationDocumentsDirectory();
    final coverDir = Directory('${appDir.path}/covers');
    if (!await coverDir.exists()) {
      await coverDir.create(recursive: true);
    }

    final coverPath = '${coverDir.path}/$playlistId.jpg';
    await File(coverPath).writeAsBytes(artwork);
    return coverPath;
  }
}
