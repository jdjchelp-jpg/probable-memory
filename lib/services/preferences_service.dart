import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wonderlapse/models/user_preferences_model.dart';

class PreferencesService {
  static const String _prefsKey = 'user_preferences';
  static const String _notificationsSentKey = 'notifications_sent';

  Future<UserPreferencesModel> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_prefsKey);
      if (jsonString != null) {
        final decoded = jsonDecode(jsonString);
        if (decoded is Map<String, dynamic>) {
          final model = UserPreferencesModel.fromJson(decoded);
          // Write back sanitized data so future loads don't fail
          await savePreferences(model);
          return model;
        } else if (decoded is Map) {
          // Coerce to Map<String, dynamic>
          final model = UserPreferencesModel.fromJson(Map<String, dynamic>.from(decoded));
          await savePreferences(model);
          return model;
        }
      }
    } catch (e) {
      print('Error loading preferences: $e');
    }
    return UserPreferencesModel.defaults();
  }

  Future<void> savePreferences(UserPreferencesModel preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(preferences.toJson());
      await prefs.setString(_prefsKey, jsonString);
    } catch (e) {
      print('Error saving preferences: $e');
    }
  }

  Future<Map<String, bool>> getNotificationsSent(int year) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_notificationsSentKey}_$year';
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        return Map<String, bool>.from(json);
      }
    } catch (e) {
      print('Error getting notifications sent: $e');
    }
    return {'oneWeek': false, 'threeDays': false, 'oneDay': false};
  }

  Future<void> setNotificationsSent(int year, Map<String, bool> sent) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_notificationsSentKey}_$year';
      final jsonString = jsonEncode(sent);
      await prefs.setString(key, jsonString);
    } catch (e) {
      print('Error setting notifications sent: $e');
    }
  }

  Future<void> resetNotificationsSent(int year) async {
    await setNotificationsSent(year, {'oneWeek': false, 'threeDays': false, 'oneDay': false});
  }
}
