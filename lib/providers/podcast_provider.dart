import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/podcast.dart';

class PodcastProvider with ChangeNotifier {
  List<Podcast> _podcasts = [];
  bool _isLoading = false;
  String? _error;

  List<Podcast> get podcasts => _podcasts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPodcasts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));
      final String jsonData =
          await rootBundle.loadString('assets/data/podcasts.json');
      final data = json.decode(jsonData);

      _podcasts = (data['podcasts'] as List)
          .map((json) => Podcast.fromJson(json))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = '加载失败：$e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleSubscribe(String podcastId) async {
    final index = _podcasts.indexWhere((p) => p.id == podcastId);
    if (index == -1) return;

    await Future.delayed(const Duration(milliseconds: 500));
    final podcast = _podcasts[index];
    final updatedPodcast = Podcast(
      id: podcast.id,
      title: podcast.title,
      author: podcast.author,
      coverUrl: podcast.coverUrl,
      description: podcast.description,
      episodeCount: podcast.episodeCount,
      subscriberCount: podcast.isSubscribed
          ? podcast.subscriberCount - 1
          : podcast.subscriberCount + 1,
      isSubscribed: !podcast.isSubscribed,
      episodes: podcast.episodes,
    );

    _podcasts[index] = updatedPodcast;
    notifyListeners();
  }
}
