import 'package:flutter/material.dart';
import 'package:wonderlapse/models/user_preferences_model.dart';
import 'package:wonderlapse/models/theme_model.dart';
import 'package:wonderlapse/localization/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wonderlapse/services/haptics_service.dart';
import 'package:wonderlapse/services/home_widget_service.dart';
import 'package:wonderlapse/screens/onboarding_screen.dart';
import 'package:wonderlapse/services/preferences_service.dart';
import 'package:wonderlapse/screens/custom_events_screen.dart';

class SettingsDrawer extends StatelessWidget {
  final UserPreferencesModel preferences;
  final Function(UserPreferencesModel) onPreferencesChanged;
  final VoidCallback onRequestNotificationPermission;

  const SettingsDrawer({
    super.key,
    required this.preferences,
    required this.onPreferencesChanged,
    required this.onRequestNotificationPermission,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(preferences.languageCode);
    final currentYear = DateTime.now().year;
    
    return Drawer(
      backgroundColor: const Color(0xFF1A1A1A),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.translate('settings.title'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              _buildSection(
                localization.translate('settings.yearSelector'),
                DropdownButton<int>(
                  value: preferences.targetYear,
                  dropdownColor: const Color(0xFF2A2A2A),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  isExpanded: true,
                  items: List.generate(36, (index) => currentYear + index).map((year) {
                    return DropdownMenuItem(value: year, child: Text('$year'));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      HapticsService.selection();
                      onPreferencesChanged(preferences.copyWith(targetYear: value));
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                localization.translate('settings.colorTheme'),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: AppThemeModel.allThemes.map((theme) {
                    final isSelected = theme.id == preferences.themeId;
                    return GestureDetector(
                      onTap: () {
                        HapticsService.selection();
                        onPreferencesChanged(preferences.copyWith(themeId: theme.id));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? theme.gradientColors[1].withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? theme.gradientColors[1] : Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          localization.translate(theme.nameKey),
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              _buildSlider(
                localization.translate('settings.snowIntensity'),
                preferences.snowIntensity,
                (value) => onPreferencesChanged(preferences.copyWith(snowIntensity: value)),
                onChangeEnd: (_) => HapticsService.selection(),
              ),
              const SizedBox(height: 24),
              _buildSlider(
                localization.translate('settings.musicVolume'),
                preferences.musicVolume,
                (value) => onPreferencesChanged(preferences.copyWith(musicVolume: value)),
                onChangeEnd: (_) => HapticsService.selection(),
              ),
              const SizedBox(height: 24),
              _buildSection(
                localization.translate('settings.customMusicUrl'),
                TextField(
                  controller: TextEditingController(text: preferences.customMusicUrl)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: preferences.customMusicUrl.length),
                    ),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'https://audio.jukehost.co.uk/...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) => onPreferencesChanged(preferences.copyWith(customMusicUrl: value)),
                ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                localization.translate('settings.notifications'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      value: preferences.notificationsEnabled,
                      onChanged: (value) {
                        HapticsService.selection();
                        if (value) onRequestNotificationPermission();
                        onPreferencesChanged(preferences.copyWith(notificationsEnabled: value));
                      },
                      title: Text(
                        localization.translate('settings.notifications'),
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      contentPadding: EdgeInsets.zero,
                      activeColor: Colors.green,
                    ),
                    if (preferences.notificationsEnabled) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: TextEditingController(text: preferences.notificationOneWeek)
                          ..selection = TextSelection.fromPosition(
                            TextPosition(offset: preferences.notificationOneWeek.length),
                          ),
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: InputDecoration(
                          labelText: localization.translate('settings.notificationOneWeek'),
                          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                          hintText: localization.translate('notifications.oneWeekDefault'),
                          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onChanged: (value) => onPreferencesChanged(preferences.copyWith(notificationOneWeek: value)),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: TextEditingController(text: preferences.notificationThreeDays)
                          ..selection = TextSelection.fromPosition(
                            TextPosition(offset: preferences.notificationThreeDays.length),
                          ),
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: InputDecoration(
                          labelText: localization.translate('settings.notificationThreeDays'),
                          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                          hintText: localization.translate('notifications.threeDaysDefault'),
                          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onChanged: (value) => onPreferencesChanged(preferences.copyWith(notificationThreeDays: value)),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: TextEditingController(text: preferences.notificationOneDay)
                          ..selection = TextSelection.fromPosition(
                            TextPosition(offset: preferences.notificationOneDay.length),
                          ),
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: InputDecoration(
                          labelText: localization.translate('settings.notificationOneDay'),
                          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                          hintText: localization.translate('notifications.oneDayDefault'),
                          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onChanged: (value) => onPreferencesChanged(preferences.copyWith(notificationOneDay: value)),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                localization.translate('settings.language'),
                DropdownButton<String>(
                  value: preferences.languageCode,
                  dropdownColor: const Color(0xFF2A2A2A),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'es', child: Text('Español')),
                    DropdownMenuItem(value: 'fr', child: Text('Français')),
                    DropdownMenuItem(value: 'nl', child: Text('Nederlands')),
                  ],
                   onChanged: (value) {
                    if (value != null) {
                       HapticsService.selection();
                      onPreferencesChanged(preferences.copyWith(languageCode: value));
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  HapticsService.mediumImpact();
                  Share.share(
                    'Join me in counting down to Christmas! 🎄',
                    subject: 'Christmas Countdown',
                  );
                },
                icon: const Icon(Icons.share, color: Colors.white),
                label: Text(
                  localization.translate('settings.share'),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.withValues(alpha: 0.7),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  HapticsService.mediumImpact();
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CustomEventsScreen()),
                  );
                },
                icon: const Icon(Icons.event, color: Colors.white),
                label: const Text('Custom Events', style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.withValues(alpha: 0.7),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                'Home Screen Widget',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Update the home screen widget with your current theme and countdown.',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              HapticsService.mediumImpact();
                              await HomeWidgetService.updateHomeScreenWidget(preferences);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Home widget updated')),
                                );
                              }
                            },
                            icon: const Icon(Icons.widgets, color: Colors.white),
                            label: const Text('Update Widget', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.withValues(alpha: 0.7),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              HapticsService.selection();
                              // Show tutorial again
                              final ps = PreferencesService();
                              await ps.savePreferences(preferences.copyWith(hasSeenOnboarding: false));
                              if (context.mounted) {
                                // Open the onboarding immediately
                                // ignore: use_build_context_synchronously
                                // Close drawer first
                                Navigator.of(context).pop();
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => OnboardingScreen(
                                      onFinish: () async {
                                        await ps.savePreferences(preferences.copyWith(hasSeenOnboarding: true));
                                      },
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.school, color: Colors.white),
                            label: const Text('View Tutorial', style: TextStyle(color: Colors.white)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Note: Widgets are visible on Android/iOS home screens, not in this preview.',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildSlider(String title, double value, ValueChanged<double> onChanged, {ValueChanged<double>? onChangeEnd}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${value.toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Colors.green,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
            thumbColor: Colors.white,
            overlayColor: Colors.green.withValues(alpha: 0.3),
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
          ),
        ),
      ],
    );
  }
}
