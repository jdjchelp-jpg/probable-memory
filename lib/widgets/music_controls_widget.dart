import 'package:flutter/material.dart';
import 'package:wonderlapse/services/haptics_service.dart';

class MusicControlsWidget extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTogglePlay;

  const MusicControlsWidget({
    super.key,
    required this.isPlaying,
    required this.onTogglePlay,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 90,
      right: 20,
      child: GestureDetector(
        onTap: () {
          HapticsService.lightImpact();
          onTogglePlay();
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
          ),
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
