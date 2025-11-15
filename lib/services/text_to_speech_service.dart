import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

class TextToSpeechService {
  static final TextToSpeechService _instance = TextToSpeechService._internal();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  factory TextToSpeechService() {
    return _instance;
  }

  TextToSpeechService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(1.0);
      await _flutterTts.setPitch(1.0);
      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) print('TTS initialization error: $e');
    }
  }

  /// Speak text with customizable parameters
  Future<void> speak(
    String text, {
    double speechRate = 1.0,
    double pitch = 1.0,
    String language = 'en-US',
  }) async {
    if (!_isInitialized) await initialize();

    try {
      await _flutterTts.setLanguage(language);
      await _flutterTts.setSpeechRate(speechRate);
      await _flutterTts.setPitch(pitch);
      await _flutterTts.speak(text);
    } catch (e) {
      if (kDebugMode) print('TTS speak error: $e');
    }
  }

  /// Stop speaking
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      if (kDebugMode) print('TTS stop error: $e');
    }
  }

  /// Pause speaking
  Future<void> pause() async {
    try {
      await _flutterTts.pause();
    } catch (e) {
      if (kDebugMode) print('TTS pause error: $e');
    }
  }

  /// Get available languages
  Future<List<String>> getAvailableLanguages() async {
    try {
      final languages = await _flutterTts.getLanguages;
      return List<String>.from(languages ?? []);
    } catch (e) {
      if (kDebugMode) print('TTS get languages error: $e');
      return ['en-US'];
    }
  }

  /// Get available voices
  Future<List<Map>> getAvailableVoices() async {
    try {
      final voices = await _flutterTts.getVoices;
      return List<Map>.from(voices ?? []);
    } catch (e) {
      if (kDebugMode) print('TTS get voices error: $e');
      return [];
    }
  }

  /// Set voice by name
  Future<void> setVoice(String voiceName) async {
    try {
      await _flutterTts.setVoice({'name': voiceName});
    } catch (e) {
      if (kDebugMode) print('TTS set voice error: $e');
    }
  }

  /// Speak countdown
  Future<void> speakCountdown(int days, int hours, int minutes, int seconds) async {
    final text = 'Christmas countdown: $days days, $hours hours, $minutes minutes, and $seconds seconds';
    await speak(text, speechRate: 0.9);
  }

  /// Speak quote
  Future<void> speakQuote(String quote) async {
    await speak(quote, speechRate: 0.85, pitch: 1.1);
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      if (kDebugMode) print('TTS dispose error: $e');
    }
  }
}
