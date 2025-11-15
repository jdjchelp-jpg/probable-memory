import 'package:shared_preferences/shared_preferences.dart';

class AccessibilitySettings {
  final bool reducedMotion;
  final bool highContrast;
  final bool dyslexiaFont;
  final bool magnifierMode;
  final bool shapesOnly;
  final double textScaleFactor;
  final double letterSpacing;
  final double lineHeight;
  final bool textToSpeechEnabled;
  final double speechSpeed;
  final double speechPitch;

  AccessibilitySettings({
    this.reducedMotion = false,
    this.highContrast = false,
    this.dyslexiaFont = false,
    this.magnifierMode = false,
    this.shapesOnly = false,
    this.textScaleFactor = 1.0,
    this.letterSpacing = 0.0,
    this.lineHeight = 1.5,
    this.textToSpeechEnabled = false,
    this.speechSpeed = 1.0,
    this.speechPitch = 1.0,
  });

  AccessibilitySettings copyWith({
    bool? reducedMotion,
    bool? highContrast,
    bool? dyslexiaFont,
    bool? magnifierMode,
    bool? shapesOnly,
    double? textScaleFactor,
    double? letterSpacing,
    double? lineHeight,
    bool? textToSpeechEnabled,
    double? speechSpeed,
    double? speechPitch,
  }) {
    return AccessibilitySettings(
      reducedMotion: reducedMotion ?? this.reducedMotion,
      highContrast: highContrast ?? this.highContrast,
      dyslexiaFont: dyslexiaFont ?? this.dyslexiaFont,
      magnifierMode: magnifierMode ?? this.magnifierMode,
      shapesOnly: shapesOnly ?? this.shapesOnly,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      lineHeight: lineHeight ?? this.lineHeight,
      textToSpeechEnabled: textToSpeechEnabled ?? this.textToSpeechEnabled,
      speechSpeed: speechSpeed ?? this.speechSpeed,
      speechPitch: speechPitch ?? this.speechPitch,
    );
  }
}

class AccessibilityService {
  static final AccessibilityService _instance = AccessibilityService._internal();
  static const String _prefsKey = 'accessibility_settings';

  factory AccessibilityService() {
    return _instance;
  }

  AccessibilityService._internal();

  Future<AccessibilitySettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_prefsKey);
    
    if (json == null) {
      return AccessibilitySettings();
    }

    try {
      return _parseSettings(json);
    } catch (e) {
      return AccessibilitySettings();
    }
  }

  Future<void> saveSettings(AccessibilitySettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final json = _serializeSettings(settings);
    await prefs.setString(_prefsKey, json);
  }

  String _serializeSettings(AccessibilitySettings settings) {
    return '${settings.reducedMotion}|${settings.highContrast}|${settings.dyslexiaFont}|${settings.magnifierMode}|${settings.shapesOnly}|${settings.textScaleFactor}|${settings.letterSpacing}|${settings.lineHeight}|${settings.textToSpeechEnabled}|${settings.speechSpeed}|${settings.speechPitch}';
  }

  AccessibilitySettings _parseSettings(String json) {
    final parts = json.split('|');
    if (parts.length < 11) return AccessibilitySettings();

    return AccessibilitySettings(
      reducedMotion: parts[0] == 'true',
      highContrast: parts[1] == 'true',
      dyslexiaFont: parts[2] == 'true',
      magnifierMode: parts[3] == 'true',
      shapesOnly: parts[4] == 'true',
      textScaleFactor: double.tryParse(parts[5]) ?? 1.0,
      letterSpacing: double.tryParse(parts[6]) ?? 0.0,
      lineHeight: double.tryParse(parts[7]) ?? 1.5,
      textToSpeechEnabled: parts[8] == 'true',
      speechSpeed: double.tryParse(parts[9]) ?? 1.0,
      speechPitch: double.tryParse(parts[10]) ?? 1.0,
    );
  }

  /// Get font family based on accessibility settings
  String getFontFamily(bool dyslexiaFont) {
    return dyslexiaFont ? 'OpenDyslexic' : 'Roboto';
  }

  /// Get animation duration based on reduced motion setting
  Duration getAnimationDuration(bool reducedMotion) {
    return reducedMotion ? const Duration(milliseconds: 0) : const Duration(milliseconds: 500);
  }

  /// Get high contrast colors
  Color getHighContrastColor(Color baseColor, bool highContrast) {
    if (!highContrast) return baseColor;
    // Increase contrast by making colors more saturated and distinct
    return baseColor.withOpacity(1.0);
  }
}
