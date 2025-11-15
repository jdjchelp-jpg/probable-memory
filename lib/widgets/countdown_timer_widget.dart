import 'package:flutter/material.dart';
import 'package:wonderlapse/localization/app_localizations.dart';

class CountdownTimerWidget extends StatelessWidget {
  final Map<String, int> countdown;
  final String languageCode;
  final Color cardTint;

  const CountdownTimerWidget({
    super.key,
    required this.countdown,
    required this.languageCode,
    required this.cardTint,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(languageCode);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeCard(countdown['days']!, localization.translate('countdown.days'), cardTint),
        const SizedBox(width: 12),
        _buildTimeCard(countdown['hours']!, localization.translate('countdown.hours'), cardTint),
        const SizedBox(width: 12),
        _buildTimeCard(countdown['minutes']!, localization.translate('countdown.minutes'), cardTint),
        const SizedBox(width: 12),
        _buildTimeCard(countdown['seconds']!, localization.translate('countdown.seconds'), cardTint),
      ],
    );
  }

  Widget _buildTimeCard(int value, String label, Color tint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
