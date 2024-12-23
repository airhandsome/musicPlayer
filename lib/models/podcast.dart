class Podcast {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final String description;
  final int episodeCount;
  final int subscriberCount;
  final bool isSubscribed;
  final List<Episode> episodes;

  Podcast({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.description,
    required this.episodeCount,
    required this.subscriberCount,
    this.isSubscribed = false,
    required this.episodes,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      coverUrl: json['coverUrl'],
      description: json['description'],
      episodeCount: json['episodeCount'],
      subscriberCount: json['subscriberCount'],
      isSubscribed: json['isSubscribed'] ?? false,
      episodes:
          (json['episodes'] as List).map((e) => Episode.fromJson(e)).toList(),
    );
  }
}

class Episode {
  final String id;
  final String title;
  final String description;
  final String audioUrl;
  final Duration duration;
  final DateTime publishDate;
  final int playCount;
  final bool isPlayed;

  Episode({
    required this.id,
    required this.title,
    required this.description,
    required this.audioUrl,
    required this.duration,
    required this.publishDate,
    required this.playCount,
    this.isPlayed = false,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      audioUrl: json['audioUrl'],
      duration: Duration(seconds: json['durationSeconds']),
      publishDate: DateTime.parse(json['publishDate']),
      playCount: json['playCount'],
      isPlayed: json['isPlayed'] ?? false,
    );
  }
}
