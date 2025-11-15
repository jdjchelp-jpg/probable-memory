import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wonderlapse/models/custom_event_model.dart';

class CustomEventsService {
  static final CustomEventsService _instance = CustomEventsService._internal();
  static const String _prefsKey = 'custom_events';

  factory CustomEventsService() {
    return _instance;
  }

  CustomEventsService._internal();

  Future<List<CustomEventModel>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_prefsKey);

    if (json == null) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(json);
      return decoded
          .map((item) => CustomEventModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveEvents(List<CustomEventModel> events) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(events.map((e) => e.toJson()).toList());
    await prefs.setString(_prefsKey, json);
  }

  Future<void> addEvent(CustomEventModel event) async {
    final events = await loadEvents();
    events.add(event);
    await saveEvents(events);
  }

  Future<void> updateEvent(CustomEventModel event) async {
    final events = await loadEvents();
    final index = events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      events[index] = event;
      await saveEvents(events);
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final events = await loadEvents();
    events.removeWhere((e) => e.id == eventId);
    await saveEvents(events);
  }

  Future<void> togglePin(String eventId) async {
    final events = await loadEvents();
    final index = events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      events[index] = events[index].copyWith(isPinned: !events[index].isPinned);
      await saveEvents(events);
    }
  }

  /// Get countdown to custom event
  Map<String, int> getCountdown(DateTime targetDate) {
    final now = DateTime.now();
    final difference = targetDate.difference(now);

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    return {
      'days': days.clamp(0, 999),
      'hours': hours.clamp(0, 23),
      'minutes': minutes.clamp(0, 59),
      'seconds': seconds.clamp(0, 59),
    };
  }

  /// Check if event is today
  bool isEventToday(DateTime targetDate) {
    final now = DateTime.now();
    return now.year == targetDate.year &&
        now.month == targetDate.month &&
        now.day == targetDate.day;
  }

  /// Get days until event
  int getDaysUntil(DateTime targetDate) {
    final now = DateTime.now();
    final difference = targetDate.difference(now);
    return difference.inDays.clamp(0, 999);
  }

  /// Get year progress percentage
  double getYearProgress(DateTime targetDate) {
    final now = DateTime.now();
    final yearStart = DateTime(targetDate.year, 1, 1);
    final yearEnd = DateTime(targetDate.year, 12, 31);

    final totalDays = yearEnd.difference(yearStart).inDays;
    final elapsedDays = now.difference(yearStart).inDays;

    if (totalDays == 0) return 0;
    return (elapsedDays / totalDays * 100).clamp(0, 100);
  }
}
