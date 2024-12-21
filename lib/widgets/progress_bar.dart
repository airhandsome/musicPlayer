import 'package:flutter/material.dart';

class MusicProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration>? onChanged;

  const MusicProgressBar({
    super.key,
    required this.position,
    required this.duration,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 6,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 14,
            ),
            activeTrackColor: Theme.of(context).primaryColor,
            inactiveTrackColor: Colors.grey[300],
            thumbColor: Theme.of(context).primaryColor,
            overlayColor: Theme.of(context).primaryColor.withOpacity(0.2),
          ),
          child: Slider(
            min: 0,
            max: duration.inMilliseconds.toDouble(),
            value: position.inMilliseconds.toDouble(),
            onChanged: (value) {
              onChanged?.call(Duration(milliseconds: value.round()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                _formatDuration(duration),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
