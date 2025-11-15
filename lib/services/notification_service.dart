import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wonderlapse/services/preferences_service.dart';
import 'package:wonderlapse/models/user_preferences_model.dart';
import 'package:wonderlapse/services/countdown_service.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final PreferencesService _prefsService = PreferencesService();
  final CountdownService _countdownService = CountdownService();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _notificationsPlugin.initialize(settings);
  }

  Future<bool> requestPermissions() async {
    final result = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    
    final iosResult = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    
    return result ?? iosResult ?? false;
  }

  Future<void> scheduleNotifications(UserPreferencesModel prefs) async {
    await _notificationsPlugin.cancelAll();

    if (!prefs.notificationsEnabled) return;

    final targetYear = prefs.targetYear;
    final christmas = _countdownService.getChristmasDate(targetYear);
    final now = DateTime.now();
    
    final notificationsSent = await _prefsService.getNotificationsSent(targetYear);

    if (!notificationsSent['oneWeek']!) {
      final oneWeekBefore = christmas.subtract(const Duration(days: 7));
      if (oneWeekBefore.isAfter(now)) {
        await _scheduleNotification(
          1,
          prefs.notificationOneWeek.isEmpty ? '🎄 Only 1 week until Christmas!' : prefs.notificationOneWeek,
          oneWeekBefore,
          'oneWeek',
          targetYear,
        );
      }
    }

    if (!notificationsSent['threeDays']!) {
      final threeDaysBefore = christmas.subtract(const Duration(days: 3));
      if (threeDaysBefore.isAfter(now)) {
        await _scheduleNotification(
          2,
          prefs.notificationThreeDays.isEmpty ? '🎅 Just 3 days left until Christmas!' : prefs.notificationThreeDays,
          threeDaysBefore,
          'threeDays',
          targetYear,
        );
      }
    }

    if (!notificationsSent['oneDay']!) {
      final oneDayBefore = christmas.subtract(const Duration(days: 1));
      if (oneDayBefore.isAfter(now)) {
        await _scheduleNotification(
          3,
          prefs.notificationOneDay.isEmpty ? '🎁 Christmas is tomorrow!' : prefs.notificationOneDay,
          oneDayBefore,
          'oneDay',
          targetYear,
        );
      }
    }
  }

  Future<void> _scheduleNotification(int id, String message, DateTime scheduledDate, String type, int year) async {
    const androidDetails = AndroidNotificationDetails(
      'christmas_countdown',
      'Christmas Countdown',
      channelDescription: 'Notifications for Christmas countdown milestones',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notificationsPlugin.zonedSchedule(
      id,
      'Christmas Countdown',
      message,
      _convertToTZDateTime(scheduledDate),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    final sent = await _prefsService.getNotificationsSent(year);
    sent[type] = true;
    await _prefsService.setNotificationsSent(year, sent);
  }

  _convertToTZDateTime(DateTime dateTime) {
    return dateTime;
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
