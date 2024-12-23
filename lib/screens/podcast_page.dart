import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/podcast.dart';
import '../providers/podcast_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PodcastPage extends StatefulWidget {
  const PodcastPage({super.key});

  @override
  State<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<PodcastProvider>().loadPodcasts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PodcastProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(provider.error!),
                ElevatedButton(
                  onPressed: provider.loadPodcasts,
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: provider.loadPodcasts,
          child: ListView.builder(
            itemCount: provider.podcasts.length + 1,
            itemBuilder: (context, index) {
              if (index == provider.podcasts.length) {
                return const SizedBox(height: 80);
              }
              return _PodcastCard(podcast: provider.podcasts[index]);
            },
          ),
        );
      },
    );
  }
}

class _PodcastCard extends StatelessWidget {
  final Podcast podcast;

  const _PodcastCard({required this.podcast});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    podcast.coverUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      podcast.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      podcast.author,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${podcast.episodeCount}集 · ${podcast.subscriberCount}人订阅',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () {
                        context
                            .read<PodcastProvider>()
                            .toggleSubscribe(podcast.id);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: podcast.isSubscribed
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        podcast.isSubscribed ? '已订阅' : '订阅',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const Divider(height: 1),
          ...podcast.episodes.map((episode) => _EpisodeItem(episode: episode)),
        ],
      ),
    );
  }
}

class _EpisodeItem extends StatelessWidget {
  final Episode episode;

  const _EpisodeItem({required this.episode});

  @override
  Widget build(BuildContext context) {
    final minutes = episode.duration.inMinutes;
    final seconds = episode.duration.inSeconds % 60;
    final durationText =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return ListTile(
      title: Text(episode.title),
      subtitle: Text(
        '${timeago.format(episode.publishDate, locale: 'zh')} · $durationText · ${episode.playCount}次播放',
      ),
      trailing: IconButton(
        icon: const Icon(Icons.play_circle_outline),
        onPressed: () {
          // TODO: 实现播放功能
        },
      ),
    );
  }
}
