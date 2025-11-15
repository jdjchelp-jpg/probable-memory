import 'package:flutter/material.dart';
import 'dart:math';

class ChristmasTreeWidget extends StatefulWidget {
  final double decorationProgress;
  final String progressText;

  const ChristmasTreeWidget({
    super.key,
    required this.decorationProgress,
    required this.progressText,
  });

  @override
  State<ChristmasTreeWidget> createState() => _ChristmasTreeWidgetState();
}

class _ChristmasTreeWidgetState extends State<ChristmasTreeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 280,
          width: 200,
          child: CustomPaint(
            painter: ChristmasTreePainter(
              decorationProgress: widget.decorationProgress,
              blinkAnimation: _blinkController,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.progressText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }
}

class ChristmasTreePainter extends CustomPainter {
  final double decorationProgress;
  final Animation<double> blinkAnimation;

  ChristmasTreePainter({
    required this.decorationProgress,
    required this.blinkAnimation,
  }) : super(repaint: blinkAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final treePaint = Paint()
      ..color = const Color(0xFF0D5E1F)
      ..style = PaintingStyle.fill;

    final trunkPaint = Paint()
      ..color = const Color(0xFF6B4226)
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    
    canvas.drawRect(
      Rect.fromLTWH(centerX - 15, size.height - 50, 30, 50),
      trunkPaint,
    );

    final treePath = Path();
    treePath.moveTo(centerX, 30);
    treePath.lineTo(centerX - 80, size.height - 50);
    treePath.lineTo(centerX + 80, size.height - 50);
    treePath.close();
    canvas.drawPath(treePath, treePaint);

    final ornaments = [
      {'x': centerX - 40, 'y': 120.0, 'color': Colors.red, 'type': '🔴'},
      {'x': centerX + 35, 'y': 140.0, 'color': Colors.yellow, 'type': '🟡'},
      {'x': centerX - 20, 'y': 160.0, 'color': Colors.blue, 'type': '🔵'},
      {'x': centerX + 50, 'y': 180.0, 'color': Colors.red, 'type': '🔴'},
      {'x': centerX - 55, 'y': 200.0, 'color': Colors.yellow, 'type': '🟡'},
      {'x': centerX + 20, 'y': 220.0, 'color': Colors.blue, 'type': '🔵'},
    ];

    final totalOrnaments = ornaments.length;
    final visibleOrnaments = (totalOrnaments * decorationProgress / 100).round();

    for (int i = 0; i < visibleOrnaments; i++) {
      final ornament = ornaments[i];
      final ornamentPaint = Paint()
        ..color = ornament['color'] as Color
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(ornament['x'] as double, ornament['y'] as double),
        8,
        ornamentPaint,
      );
    }

    if (decorationProgress > 30) {
      final lights = [
        Offset(centerX - 30, 100),
        Offset(centerX + 25, 130),
        Offset(centerX - 50, 150),
        Offset(centerX + 40, 170),
        Offset(centerX - 10, 190),
        Offset(centerX + 60, 210),
      ];

      final lightPaint = Paint()
        ..color = Colors.yellow.withValues(alpha: 0.5 + blinkAnimation.value * 0.5)
        ..style = PaintingStyle.fill;

      final visibleLights = (lights.length * (decorationProgress - 30) / 70).round();
      for (int i = 0; i < visibleLights && i < lights.length; i++) {
        canvas.drawCircle(lights[i], 6, lightPaint);
      }
    }

    if (decorationProgress > 90) {
      final starPaint = Paint()
        ..color = Colors.amber
        ..style = PaintingStyle.fill;

      final starPath = Path();
      for (int i = 0; i < 10; i++) {
        final angle = (i * pi / 5) - pi / 2;
        final radius = i.isEven ? 15.0 : 7.0;
        final x = centerX + cos(angle) * radius;
        final y = 25 + sin(angle) * radius;
        if (i == 0) {
          starPath.moveTo(x, y);
        } else {
          starPath.lineTo(x, y);
        }
      }
      starPath.close();
      canvas.drawPath(starPath, starPaint);
    }
  }

  @override
  bool shouldRepaint(ChristmasTreePainter oldDelegate) => true;
}
