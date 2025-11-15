import 'package:flutter/material.dart';
import 'dart:math';

class SparkleParticles extends StatefulWidget {
  final Color color;

  const SparkleParticles({super.key, required this.color});

  @override
  State<SparkleParticles> createState() => _SparkleParticlesState();
}

class _SparkleParticlesState extends State<SparkleParticles> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Sparkle> _sparkles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 8))
      ..addListener(() {
        setState(() {
          for (var sparkle in _sparkles) {
            sparkle.update();
          }
        });
      })
      ..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeSparkles();
  }

  void _initializeSparkles() {
    final size = MediaQuery.of(context).size;
    _sparkles.clear();
    for (int i = 0; i < 30; i++) {
      _sparkles.add(Sparkle(
        x: _random.nextDouble() * size.width,
        y: _random.nextDouble() * size.height,
        speed: 0.2 + _random.nextDouble() * 0.5,
        size: 3 + _random.nextDouble() * 3,
        opacity: _random.nextDouble(),
        fadeSpeed: 0.01 + _random.nextDouble() * 0.02,
        fadeDirection: _random.nextBool() ? 1 : -1,
        screenHeight: size.height,
        screenWidth: size.width,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SparklePainter(_sparkles, widget.color),
      size: Size.infinite,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Sparkle {
  double x;
  double y;
  final double speed;
  final double size;
  double opacity;
  final double fadeSpeed;
  int fadeDirection;
  final double screenHeight;
  final double screenWidth;

  Sparkle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.fadeSpeed,
    required this.fadeDirection,
    required this.screenHeight,
    required this.screenWidth,
  });

  void update() {
    y -= speed;
    opacity += fadeSpeed * fadeDirection;
    
    if (opacity >= 1) {
      opacity = 1;
      fadeDirection = -1;
    } else if (opacity <= 0) {
      opacity = 0;
      fadeDirection = 1;
    }
    
    if (y < -10) {
      y = screenHeight + 10;
      x = Random().nextDouble() * screenWidth;
    }
  }
}

class SparklePainter extends CustomPainter {
  final List<Sparkle> sparkles;
  final Color color;

  SparklePainter(this.sparkles, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    for (var sparkle in sparkles) {
      final paint = Paint()
        ..color = color.withValues(alpha: sparkle.opacity)
        ..style = PaintingStyle.fill;

      final path = Path();
      final centerX = sparkle.x;
      final centerY = sparkle.y;
      final outerRadius = sparkle.size;
      final innerRadius = sparkle.size / 2;

      for (int i = 0; i < 8; i++) {
        final angle = (i * pi / 4);
        final outerX = centerX + cos(angle) * outerRadius;
        final outerY = centerY + sin(angle) * outerRadius;
        
        if (i == 0) {
          path.moveTo(outerX, outerY);
        } else {
          path.lineTo(outerX, outerY);
        }
        
        final innerAngle = angle + pi / 8;
        final innerX = centerX + cos(innerAngle) * innerRadius;
        final innerY = centerY + sin(innerAngle) * innerRadius;
        path.lineTo(innerX, innerY);
      }
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(SparklePainter oldDelegate) => true;
}
