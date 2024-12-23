class Playlist {
  final String id;
  final String title;
  final String description;
  String coverUrl;
  final String creatorId;
  final String creatorName;
  final List<String> songIds;
  final int playCount;
  final bool isOfficial;

  Playlist({
    required this.id,
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.creatorId,
    required this.creatorName,
    required this.songIds,
    required this.playCount,
    required this.isOfficial,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      coverUrl: json['coverUrl'],
      creatorId: json['creatorId'],
      creatorName: json['creatorName'],
      songIds: List<String>.from(json['songIds']),
      playCount: json['playCount'],
      isOfficial: json['isOfficial'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'coverUrl': coverUrl,
      'songIds': songIds,
    };
  }
}
