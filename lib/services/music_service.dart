import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/song.dart';
import '../models/playlist.dart';

class MusicService {
  Future<List<Song>> getSongs() async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 800));

    final String response =
        await rootBundle.loadString('assets/data/songs.json');
    final data = json.decode(response);
    return (data['songs'] as List).map((json) => Song.fromJson(json)).toList();
  }

  Future<List<Playlist>> getPlaylists() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final String response =
        await rootBundle.loadString('assets/data/playlists.json');
    final data = json.decode(response);
    return (data['playlists'] as List)
        .map((json) => Playlist.fromJson(json))
        .toList();
  }

  Future<Playlist> getPlaylistById(String id) async {
    final playlists = await getPlaylists();
    return playlists.firstWhere((playlist) => playlist.id == id);
  }

  Future<Song> getSongById(String id) async {
    final songs = await getSongs();
    return songs.firstWhere((song) => song.id == id);
  }
}
