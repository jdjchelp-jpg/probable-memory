import 'package:flutter/material.dart';
import 'dart:async';
import 'package:wonderlapse/models/user_preferences_model.dart';
import 'package:wonderlapse/models/theme_model.dart';
import 'package:wonderlapse/services/preferences_service.dart';
import 'package:wonderlapse/services/countdown_service.dart';
import 'package:wonderlapse/services/notification_service.dart';
import 'package:wonderlapse/services/music_service.dart';
import 'package:wonderlapse/localization/app_localizations.dart';
import 'package:wonderlapse/widgets/snowfall_animation.dart';
import 'package:wonderlapse/widgets/sparkle_particles.dart';
import 'package:wonderlapse/widgets/santa_sleigh_animation.dart';
import 'package:wonderlapse/widgets/confetti_animation.dart';
import 'package:wonderlapse/widgets/christmas_tree_widget.dart';
import 'package:wonderlapse/widgets/gift_boxes_widget.dart';
import 'package:wonderlapse/widgets/countdown_timer_widget.dart';
import 'package:wonderlapse/widgets/progress_circle_widget.dart';
import 'package:wonderlapse/widgets/holiday_quote_widget.dart';
import 'package:wonderlapse/widgets/music_controls_widget.dart';
import 'package:wonderlapse/widgets/settings_drawer.dart';
import 'package:wonderlapse/services/haptics_service.dart';
import 'package:wonderlapse/screens/onboarding_screen.dart';
import 'package:wonderlapse/widgets/weather_widget.dart';
import 'package:wonderlapse/services/holiday_facts_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PreferencesService _prefsService = PreferencesService();
  final CountdownService _countdownService = CountdownService();
  final NotificationService _notificationService = NotificationService();
  final MusicService _musicService = MusicService();

  UserPreferencesModel? _preferences;
  Map<String, int> _countdown = {'days': 0, 'hours': 0, 'minutes': 0, 'seconds': 0};
  Timer? _timer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _notificationService.initialize();
    await _musicService.initialize();
    
    final prefs = await _prefsService.loadPreferences();
    setState(() {
      _preferences = prefs;
      _isLoading = false;
    });

    _updateCountdown();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCountdown());

    if (prefs.musicPlaying) {
      await _musicService.play(prefs.customMusicUrl, prefs.musicVolume);
    }

    if (prefs.notificationsEnabled) {
      await _notificationService.scheduleNotifications(prefs);
    }

    if (!prefs.hasSeenOnboarding) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOnboarding();
      });
    }
  }

  void _updateCountdown() {
    if (_preferences == null) return;

    if (_countdownService.shouldAutoRollover(_preferences!.targetYear)) {
      final nextYear = _countdownService.getNextYear(_preferences!.targetYear);
      _updatePreferences(_preferences!.copyWith(targetYear: nextYear));
      _prefsService.resetNotificationsSent(nextYear);
    }

    setState(() {
      _countdown = _countdownService.getCountdown(_preferences!.targetYear);
    });
  }

  void _updatePreferences(UserPreferencesModel newPrefs) async {
    setState(() => _preferences = newPrefs);
    await _prefsService.savePreferences(newPrefs);

    if (newPrefs.notificationsEnabled) {
      await _notificationService.scheduleNotifications(newPrefs);
    } else {
      await _notificationService.cancelAllNotifications();
    }

    await _musicService.setVolume(newPrefs.musicVolume);
  }

  Future<void> _toggleMusic() async {
    if (_preferences == null) return;

    if (_preferences!.musicPlaying) {
      await _musicService.pause();
      _updatePreferences(_preferences!.copyWith(musicPlaying: false));
    } else {
      if (_musicService.isPlaying) {
        await _musicService.resume();
      } else {
        await _musicService.play(_preferences!.customMusicUrl, _preferences!.musicVolume);
      }
      _updatePreferences(_preferences!.copyWith(musicPlaying: true));
    }
  }

  Future<void> _requestNotificationPermission() async {
    await _notificationService.requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _preferences == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1A1A),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final theme = AppThemeModel.getById(_preferences!.themeId);
    final localization = AppLocalizations.of(_preferences!.languageCode);
    final isChristmas = _countdownService.isChristmasDay(_preferences!.targetYear);
    final showTree = _countdownService.shouldShowTree(_preferences!.targetYear);
    final treeProgress = _countdownService.getTreeDecorationProgress(_preferences!.targetYear);
    final yearProgress = _countdownService.getYearProgress(_preferences!.targetYear);
    final daysRemaining = _countdownService.getDaysUntilChristmas(_preferences!.targetYear);

    return Scaffold(
      drawer: SettingsDrawer(
        preferences: _preferences!,
        onPreferencesChanged: _updatePreferences,
        onRequestNotificationPermission: _requestNotificationPermission,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.gradientColors,
          ),
        ),
        child: Stack(
          children: [
            SnowfallAnimation(intensity: _preferences!.snowIntensity, color: Colors.white),
            SparkleParticles(color: theme.sparkleColor),
            const SantaSleighAnimation(),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, right: 16),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white, size: 32),
                            onPressed: () {
                              HapticsService.selection();
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.white, size: 28),
                        const SizedBox(width: 12),
                        Text(
                          '${localization.translate('countdown.christmas')} ${_preferences!.targetYear}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: WeatherWidget(cardTint: theme.cardTint),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardTint,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '📚 Daily Fact',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              HolidayFactsService.getDailyFact(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardTint,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Center(
                          child: Text(
                            HolidayFactsService.getDailyMessage(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const HolidayQuoteWidget(),
                    const SizedBox(height: 40),
                    if (isChristmas)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          localization.translate('countdown.itsChristmas'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      CountdownTimerWidget(
                        countdown: _countdown,
                        languageCode: _preferences!.languageCode,
                        cardTint: theme.cardTint,
                      ),
                    const SizedBox(height: 40),
                    if (showTree)
                      ChristmasTreeWidget(
                        decorationProgress: treeProgress,
                        progressText: '${localization.translate('tree.decorationProgress')}: ${treeProgress.toInt()}%',
                      ),
                    const SizedBox(height: 40),
                    ProgressCircleWidget(
                      progress: yearProgress,
                      daysRemaining: daysRemaining,
                      progressText: '${yearProgress.toInt()}% ${localization.translate('countdown.yearComplete')}',
                      gradientColors: theme.gradientColors,
                    ),
                    const SizedBox(height: 60),
                    const GiftBoxesWidget(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            ConfettiAnimation(isChristmas: isChristmas),
            MusicControlsWidget(
              isPlaying: _preferences!.musicPlaying,
              onTogglePlay: _toggleMusic,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _musicService.dispose();
    super.dispose();
  }

  void _showOnboarding() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => OnboardingScreen(
          onFinish: () {
            if (_preferences != null) {
              _updatePreferences(_preferences!.copyWith(hasSeenOnboarding: true));
            }
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
