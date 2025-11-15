import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ConfettiAnimation extends StatefulWidget {
  final bool isChristmas;

  const ConfettiAnimation({super.key, required this.isChristmas});

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation> {
  late ConfettiController _controller;
  bool _hasPlayed = false;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 5));
  }

  @override
  void didUpdateWidget(ConfettiAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isChristmas && !_hasPlayed) {
      _controller.play();
      _hasPlayed = true;
    } else if (!widget.isChristmas) {
      _hasPlayed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _controller,
        blastDirectionality: BlastDirectionality.explosive,
        particleDrag: 0.05,
        emissionFrequency: 0.05,
        numberOfParticles: 30,
        gravity: 0.1,
        shouldLoop: false,
        colors: const [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow,
          Colors.purple,
          Colors.orange,
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
