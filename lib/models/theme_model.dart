import 'package:flutter/material.dart';

class AppThemeModel {
  final String id;
  final String nameKey;
  final List<Color> gradientColors;
  final Color cardTint;
  final Color sparkleColor;

  const AppThemeModel({
    required this.id,
    required this.nameKey,
    required this.gradientColors,
    required this.cardTint,
    required this.sparkleColor,
  });

  static const classic = AppThemeModel(
    id: 'classic',
    nameKey: 'themes.classic',
    gradientColors: [Color(0xFF7F1D1D), Color(0xFF14532D), Color(0xFF7F1D1D)],
    cardTint: Color(0x33EF4444),
    sparkleColor: Color(0xFFFDE047),
  );

  static const winter = AppThemeModel(
    id: 'winter',
    nameKey: 'themes.winter',
    gradientColors: [Color(0xFF1E3A8A), Color(0xFFFFFFFF), Color(0xFF60A5FA)],
    cardTint: Color(0x333B82F6),
    sparkleColor: Color(0xFFE0F2FE),
  );

  static const royal = AppThemeModel(
    id: 'royal',
    nameKey: 'themes.royal',
    gradientColors: [Color(0xFF581C87), Color(0xFF92400E), Color(0xFFEAB308)],
    cardTint: Color(0x33A855F7),
    sparkleColor: Color(0xFFFBBF24),
  );

  static const candy = AppThemeModel(
    id: 'candy',
    nameKey: 'themes.candy',
    gradientColors: [Color(0xFF9F1239), Color(0xFFEC4899), Color(0xFFDC2626)],
    cardTint: Color(0x33F472B6),
    sparkleColor: Color(0xFFFCE7F3),
  );

  static const golden = AppThemeModel(
    id: 'golden',
    nameKey: 'themes.golden',
    gradientColors: [Color(0xFF78350F), Color(0xFFFBBF24), Color(0xFFEA580C)],
    cardTint: Color(0x33FBBF24),
    sparkleColor: Color(0xFFFEF3C7),
  );

  static const icy = AppThemeModel(
    id: 'icy',
    nameKey: 'themes.icy',
    gradientColors: [Color(0xFF0F172A), Color(0xFF475569), Color(0xFF0C4A6E)],
    cardTint: Color(0x3364748B),
    sparkleColor: Color(0xFF7DD3FC),
  );

  static const forest = AppThemeModel(
    id: 'forest',
    nameKey: 'themes.forest',
    gradientColors: [Color(0xFF14532D), Color(0xFF047857), Color(0xFF0F766E)],
    cardTint: Color(0x3310B981),
    sparkleColor: Color(0xFF6EE7B7),
  );

  static const sunset = AppThemeModel(
    id: 'sunset',
    nameKey: 'themes.sunset',
    gradientColors: [Color(0xFFEA580C), Color(0xFFFB923C), Color(0xFFF43F5E)],
    cardTint: Color(0x33FB923C),
    sparkleColor: Color(0xFFFED7AA),
  );

  static const aurora = AppThemeModel(
    id: 'aurora',
    nameKey: 'themes.aurora',
    gradientColors: [Color(0xFF4C1D95), Color(0xFF6366F1), Color(0xFFDB2777)],
    cardTint: Color(0x338B5CF6),
    sparkleColor: Color(0xFFE9D5FF),
  );

  static List<AppThemeModel> get allThemes => [
    classic, winter, royal, candy, golden, icy, forest, sunset, aurora,
  ];

  static AppThemeModel getById(String id) =>
      allThemes.firstWhere((theme) => theme.id == id, orElse: () => classic);
}
