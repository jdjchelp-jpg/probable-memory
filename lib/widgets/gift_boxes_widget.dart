import 'package:flutter/material.dart';
import 'package:wonderlapse/services/haptics_service.dart';

class GiftBoxesWidget extends StatefulWidget {
  const GiftBoxesWidget({super.key});

  @override
  State<GiftBoxesWidget> createState() => _GiftBoxesWidgetState();
}

class _GiftBoxesWidgetState extends State<GiftBoxesWidget> with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );
      _controllers.add(controller);
      
      final animation = Tween<double>(begin: 0, end: -15).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
      _animations.add(animation);
      
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          controller.repeat(reverse: true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animations[index].value),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () {
                    HapticsService.selection();
                  },
                  child: const Text(
                    '🎁',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
