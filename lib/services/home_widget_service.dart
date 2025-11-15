import 'package:home_widget/home_widget.dart';
import 'package:wonderlapse/models/user_preferences_model.dart';
import 'package:wonderlapse/models/theme_model.dart';
import 'package:wonderlapse/services/countdown_service.dart';

class HomeWidgetService {
  static const String _androidWidgetProvider = 'HomeWidgetProvider';

  static Future<void> updateHomeScreenWidget(UserPreferencesModel prefs) async {
    final countdownService = CountdownService();
    final countdown = countdownService.getCountdown(prefs.targetYear);
    final theme = AppThemeModel.getById(prefs.themeId);

    await HomeWidget.saveWidgetData('title', 'Christmas ${prefs.targetYear}');
    await HomeWidget.saveWidgetData('days', countdown['days'] ?? 0);
    await HomeWidget.saveWidgetData('hours', countdown['hours'] ?? 0);
    await HomeWidget.saveWidgetData('minutes', countdown['minutes'] ?? 0);
    await HomeWidget.saveWidgetData('seconds', countdown['seconds'] ?? 0);
    await HomeWidget.saveWidgetData('themeStart', theme.gradientColors.first.value);
    await HomeWidget.saveWidgetData('themeEnd', theme.gradientColors.last.value);

    // Name is optional for Android if default provider is used
    await HomeWidget.updateWidget(name: _androidWidgetProvider);
  }
}
