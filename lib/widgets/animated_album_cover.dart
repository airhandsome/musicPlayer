import 'package:flutter/material.dart';

class AnimatedAlbumCover extends StatefulWidget {
  final String imageUrl;
  final bool isPlaying;

  const AnimatedAlbumCover({
    super.key,
    required this.imageUrl,
    required this.isPlaying,
  });

  @override
  State<AnimatedAlbumCover> createState() => _AnimatedAlbumCoverState();
}

class _AnimatedAlbumCoverState extends State<AnimatedAlbumCover>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void didUpdateWidget(AnimatedAlbumCover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.network(
            widget.imageUrl,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
