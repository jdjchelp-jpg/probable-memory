import 'package:flutter/material.dart';

class SantaSleighAnimation extends StatefulWidget {
  const SantaSleighAnimation({super.key});

  @override
  State<SantaSleighAnimation> createState() => _SantaSleighAnimationState();
}

class _SantaSleighAnimationState extends State<SantaSleighAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _animation = Tween<double>(begin: -200, end: 1).animate(_controller);
    
    _scheduleNextFlight();
  }

  void _scheduleNextFlight() {
    Future.delayed(const Duration(seconds: 60), () {
      if (mounted) {
        setState(() => _isVisible = true);
        _controller.forward(from: 0).then((_) {
          if (mounted) {
            setState(() => _isVisible = false);
            _scheduleNextFlight();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final position = _animation.value < 0 
            ? _animation.value 
            : screenWidth * _animation.value + 200;
        
        return Positioned(
          left: position,
          top: 100,
          child: const Text(
            '🎅🦌🛷',
            style: TextStyle(fontSize: 48),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
