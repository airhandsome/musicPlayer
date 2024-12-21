class PodcastEpisode {
  final String id;
  final String title;
  final String description;
  final String audioUrl;
  final Duration duration;
  final DateTime publishDate;
  final int playCount;

  PodcastEpisode({
    required this.id,
    required this.title,
    required this.description,
    required this.audioUrl,
    required this.duration,
    required this.publishDate,
    this.playCount = 0,
  });

  factory PodcastEpisode.fromJson(Map<String, dynamic> json) {
    return PodcastEpisode(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      audioUrl: json['audioUrl'] as String,
      duration: Duration(seconds: json['duration'] as int),
      publishDate: DateTime.parse(json['publishDate'] as String),
      playCount: json['playCount'] as int? ?? 0,
    );
  }
}

class Podcast {
  final String id;
  final String title;
  final String description;
  final String coverUrl;
  final String author;
  final List<String> categories;
  final List<PodcastEpisode> episodes;
  final int subscriberCount;

  Podcast({
    required this.id,
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.author,
    required this.categories,
    required this.episodes,
    this.subscriberCount = 0,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      coverUrl: json['coverUrl'] as String,
      author: json['author'] as String,
      categories: (json['categories'] as List).cast<String>(),
      episodes: (json['episodes'] as List)
          .map((episodeJson) => PodcastEpisode.fromJson(episodeJson))
          .toList(),
      subscriberCount: json['subscriberCount'] as int? ?? 0,
    );
  }
}
