import 'package:flutter/material.dart';
import 'dart:math';

class SnowfallAnimation extends StatefulWidget {
  final double intensity;
  final Color color;

  const SnowfallAnimation({super.key, required this.intensity, this.color = Colors.white});

  @override
  State<SnowfallAnimation> createState() => _SnowfallAnimationState();
}

class _SnowfallAnimationState extends State<SnowfallAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Snowflake> _snowflakes = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..addListener(() {
        setState(() {
          for (var snowflake in _snowflakes) {
            snowflake.update();
          }
        });
      })
      ..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeSnowflakes();
  }

  @override
  void didUpdateWidget(SnowfallAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.intensity != widget.intensity) {
      _initializeSnowflakes();
    }
  }

  void _initializeSnowflakes() {
    final size = MediaQuery.of(context).size;
    _snowflakes.clear();
    final count = (widget.intensity * 1).toInt();
    for (int i = 0; i < count; i++) {
      _snowflakes.add(Snowflake(
        x: _random.nextDouble() * size.width,
        y: _random.nextDouble() * size.height,
        speed: 0.5 + _random.nextDouble() * 1.5,
        size: 2 + _random.nextDouble() * 4,
        screenHeight: size.height,
        screenWidth: size.width,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SnowfallPainter(_snowflakes, widget.color),
      size: Size.infinite,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Snowflake {
  double x;
  double y;
  final double speed;
  final double size;
  final double screenHeight;
  final double screenWidth;

  Snowflake({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.screenHeight,
    required this.screenWidth,
  });

  void update() {
    y += speed;
    x += sin(y / 30) * 0.5;
    if (y > screenHeight) {
      y = -10;
      x = Random().nextDouble() * screenWidth;
    }
  }
}

class SnowfallPainter extends CustomPainter {
  final List<Snowflake> snowflakes;
  final Color color;

  SnowfallPainter(this.snowflakes, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    for (var snowflake in snowflakes) {
      canvas.drawCircle(
        Offset(snowflake.x, snowflake.y),
        snowflake.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(SnowfallPainter oldDelegate) => true;
}
