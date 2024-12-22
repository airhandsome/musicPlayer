class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String coverUrl;
  final String audioUrl;
  final Duration duration;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.coverUrl,
    required this.audioUrl,
    required this.duration,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      coverUrl: json['coverUrl'],
      audioUrl: json['audioUrl'],
      duration: Duration(seconds: json['duration']),
    );
  }
}
