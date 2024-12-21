import 'song.dart';

class Playlist {
  final String id;
  final String title;
  final String description;
  final String coverUrl;
  final String creatorId;
  final String creatorName;
  final List<Song> songs;
  final int playCount;
  final bool isOfficial;

  Playlist({
    required this.id,
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.creatorId,
    required this.creatorName,
    required this.songs,
    this.playCount = 0,
    this.isOfficial = false,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      coverUrl: json['coverUrl'] as String,
      creatorId: json['creatorId'] as String,
      creatorName: json['creatorName'] as String,
      songs: (json['songs'] as List)
          .map((songJson) => Song.fromJson(songJson))
          .toList(),
      playCount: json['playCount'] as int? ?? 0,
      isOfficial: json['isOfficial'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'coverUrl': coverUrl,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'songs': songs.map((song) => song.toJson()).toList(),
      'playCount': playCount,
      'isOfficial': isOfficial,
    };
  }
}
