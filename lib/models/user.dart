import 'playlist.dart';

class User {
  final String id;
  final String username;
  final String? avatarUrl;
  final bool isVip;
  final List<Playlist> createdPlaylists;
  final List<Playlist> likedPlaylists;
  final List<String> likedSongIds;
  final List<String> followingIds;
  final List<String> followerIds;

  User({
    required this.id,
    required this.username,
    this.avatarUrl,
    this.isVip = false,
    this.createdPlaylists = const [],
    this.likedPlaylists = const [],
    this.likedSongIds = const [],
    this.followingIds = const [],
    this.followerIds = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      isVip: json['isVip'] as bool? ?? false,
      createdPlaylists: (json['createdPlaylists'] as List?)
              ?.map((playlistJson) => Playlist.fromJson(playlistJson))
              .toList() ??
          [],
      likedPlaylists: (json['likedPlaylists'] as List?)
              ?.map((playlistJson) => Playlist.fromJson(playlistJson))
              .toList() ??
          [],
      likedSongIds: (json['likedSongIds'] as List?)?.cast<String>() ?? [],
      followingIds: (json['followingIds'] as List?)?.cast<String>() ?? [],
      followerIds: (json['followerIds'] as List?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatarUrl': avatarUrl,
      'isVip': isVip,
      'createdPlaylists':
          createdPlaylists.map((playlist) => playlist.toJson()).toList(),
      'likedPlaylists':
          likedPlaylists.map((playlist) => playlist.toJson()).toList(),
      'likedSongIds': likedSongIds,
      'followingIds': followingIds,
      'followerIds': followerIds,
    };
  }
}
