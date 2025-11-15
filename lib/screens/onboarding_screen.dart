import 'package:flutter/material.dart';
import 'package:wonderlapse/models/theme_model.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const OnboardingScreen({super.key, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  void _next() {
    if (_index < 2) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      widget.onFinish();
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeModel.getById('classic');
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.gradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton.icon(
                  onPressed: () {
                    widget.onFinish();
                    Navigator.of(context).maybePop();
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text('Skip', style: TextStyle(color: Colors.white)),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _index = i),
                  children: const [
                    _OnboardPage(
                      icon: Icons.auto_awesome,
                      title: 'Magical Atmosphere',
                      desc: 'Snowfall, sparkles, and animations bring Christmas to life.',
                    ),
                    _OnboardPage(
                      icon: Icons.palette,
                      title: 'Custom Themes',
                      desc: 'Pick a gradient theme and tune snow and music volume.',
                    ),
                    _OnboardPage(
                      icon: Icons.notifications_active,
                      title: 'Reminders & Music',
                      desc: 'Schedule notifications and play festive tunes while you count down.',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(3, (i) {
                        final active = i == _index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          height: 8,
                          width: active ? 24 : 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: active ? 0.9 : 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      }),
                    ),
                    ElevatedButton.icon(
                      onPressed: _next,
                      icon: Icon(_index < 2 ? Icons.arrow_forward : Icons.check, color: Colors.white),
                      label: Text(_index < 2 ? 'Next' : 'Get Started', style: const TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.withValues(alpha: 0.8),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  final IconData icon; 
  final String title; 
  final String desc;
  const _OnboardPage({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 72),
          const SizedBox(height: 24),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(desc, style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
