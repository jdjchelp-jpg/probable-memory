# Quick Reference Guide

## 🚀 Quick Start

```bash
# Clone and setup
git clone <repo>
cd legendary-train
flutter pub get

# Run the app
flutter run
```

## 📱 Main Screens

| Screen | File | Purpose |
|--------|------|---------|
| Home | `screens/home_screen.dart` | Main countdown display |
| Onboarding | `screens/onboarding_screen.dart` | Tutorial |
| Custom Events | `screens/custom_events_screen.dart` | Event management |

## 🎨 Key Widgets

| Widget | File | Purpose |
|--------|------|---------|
| Countdown Timer | `widgets/countdown_timer_widget.dart` | Display timer |
| Progress Circle | `widgets/progress_circle_widget.dart` | Year progress |
| Christmas Tree | `widgets/christmas_tree_widget.dart` | Dec 24-25 special |
| Settings Drawer | `widgets/settings_drawer.dart` | All settings |
| Weather | `widgets/weather_widget.dart` | Weather display |
| Gift Planner | `widgets/gift_planner_widget.dart` | Gift management |
| Accessibility | `widgets/accessibility_settings_widget.dart` | A11y options |

## 🔧 Key Services

| Service | File | Key Methods |
|---------|------|-------------|
| Countdown | `services/countdown_service.dart` | `getCountdown()`, `isChristmasDay()` |
| Preferences | `services/preferences_service.dart` | `loadPreferences()`, `savePreferences()` |
| Music | `services/music_service.dart` | `play()`, `pause()`, `setVolume()` |
| Notifications | `services/notification_service.dart` | `scheduleNotifications()` |
| Weather | `services/weather_service.dart` | `getWeather()` |
| Accessibility | `services/accessibility_service.dart` | `loadSettings()`, `saveSettings()` |
| Custom Events | `services/custom_events_service.dart` | `addEvent()`, `deleteEvent()` |
| Gift Planner | `services/gift_planner_service.dart` | `addGift()`, `getStats()` |
| TTS | `services/text_to_speech_service.dart` | `speak()`, `stop()` |
| Facts | `services/holiday_facts_service.dart` | `getDailyFact()`, `getDailyMessage()` |

## 📊 Data Models

| Model | File | Purpose |
|-------|------|---------|
| UserPreferences | `models/user_preferences_model.dart` | User settings |
| Theme | `models/theme_model.dart` | Theme definitions |
| CustomEvent | `models/custom_event_model.dart` | Custom events |
| Gift | `models/gift_model.dart` | Gift entries |

## 🎨 Theme Colors

```dart
// Access current theme
final theme = AppThemeModel.getById(preferences.themeId);

// Theme properties
theme.gradientColors      // List<Color> for gradient
theme.cardTint           // Color for cards
theme.sparkleColor       // Color for sparkles
theme.name               // Theme name
theme.id                 // Theme ID
```

## 🌍 Localization

```dart
// Get localization
final loc = AppLocalizations.of(languageCode);

// Translate text
loc.translate('countdown.christmas')
loc.translate('settings.title')
```

## 💾 Data Storage

```dart
// All data uses SharedPreferences
final prefs = await SharedPreferences.getInstance();

// Custom events (JSON)
final events = await CustomEventsService().loadEvents();

// Gifts (JSON)
final gifts = await GiftPlannerService().loadGifts();

// Accessibility (pipe-delimited)
final a11y = await AccessibilityService().loadSettings();
```

## 🎵 Audio Control

```dart
// Music service
final music = MusicService();
await music.play(url, volume);
await music.pause();
await music.setVolume(volume);

// Text-to-speech
final tts = TextToSpeechService();
await tts.speak(text, speechRate: 1.0, pitch: 1.0);
await tts.stop();
```

## 🔔 Notifications

```dart
// Schedule notifications
final notif = NotificationService();
await notif.initialize();
await notif.scheduleNotifications(preferences);

// Request permissions
await notif.requestPermissions();
```

## ♿ Accessibility

```dart
// Load accessibility settings
final a11y = AccessibilityService();
final settings = await a11y.loadSettings();

// Check settings
settings.reducedMotion
settings.highContrast
settings.dyslexiaFont
settings.magnifierMode
settings.textToSpeechEnabled
```

## 🎁 Gift Planner

```dart
// Create gift
final gift = GiftModel(
  id: Uuid().v4(),
  name: 'Gift Name',
  recipient: 'John',
  category: 'Electronics',
  estimatedCost: 50.0,
);

// Save gift
await GiftPlannerService().addGift(gift);

// Get statistics
final stats = await GiftPlannerService().getStats();
print('${stats.purchased}/${stats.total} purchased');
```

## 📅 Custom Events

```dart
// Create event
final event = CustomEventModel(
  id: Uuid().v4(),
  name: 'Birthday',
  targetDate: DateTime(2025, 3, 15),
  icon: '🎂',
  themeId: 'classic',
);

// Save event
await CustomEventsService().addEvent(event);

// Get countdown
final countdown = CustomEventsService().getCountdown(event.targetDate);
```

## 🌤️ Weather

```dart
// Get weather
final weather = await WeatherService().getWeather();
print('${weather.temperature}°C');
print(weather.condition);
print(weather.icon);

// Get description for accessibility
final desc = WeatherService().getWeatherDescription(weather);
```

## 📚 Daily Content

```dart
// Get daily fact
final fact = HolidayFactsService.getDailyFact();

// Get daily message
final message = HolidayFactsService.getDailyMessage();

// Get random (not daily)
final randomFact = HolidayFactsService.getRandomFact();
```

## 🎯 Common Tasks

### Add New Theme
1. Update `models/theme_model.dart`
2. Add to `AppThemeModel.themes` list
3. Define gradient colors and card tint

### Add New Language
1. Update `localization/app_localizations.dart`
2. Add language code to dropdown
3. Add translations for all keys

### Integrate Weather API
1. Get API key from OpenWeatherMap
2. Update `services/weather_service.dart`
3. Replace mock data with API call

### Add New Accessibility Feature
1. Add property to `AccessibilitySettings`
2. Add UI control in `accessibility_settings_widget.dart`
3. Apply setting in relevant widgets

### Add New Animation
1. Create widget in `widgets/`
2. Use `AnimationController` and `Tween`
3. Add to home screen stack

## 🐛 Debugging

```dart
// Enable debug logging
flutter run -v

// Check device logs
flutter logs

// Hot reload
Press 'r' in terminal

// Hot restart
Press 'R' in terminal

// Stop app
Press 'q' in terminal
```

## 📦 Build Commands

```bash
# Android APK
flutter build apk --release

# iOS IPA
flutter build ios --release

# Web
flutter build web --release

# Clean build
flutter clean
flutter pub get
flutter run
```

## 🔗 Important Links

- [Flutter Docs](https://flutter.dev/docs)
- [Dart Docs](https://dart.dev/guides)
- [OpenWeatherMap API](https://openweathermap.org/api)
- [JukeHost Music](https://jukehost.co.uk)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)
- [Flutter TTS](https://pub.dev/packages/flutter_tts)

## 💡 Tips & Tricks

1. **Performance**: Reduce snow intensity on older devices
2. **Testing**: Use reduced motion mode to test animations
3. **Accessibility**: Test with screen reader enabled
4. **Localization**: Add new languages in one place
5. **Themes**: Create new themes by copying existing ones
6. **Storage**: All data persists automatically
7. **Notifications**: Test with different times
8. **Music**: Use JukeHost for easy music hosting

## ⚠️ Common Issues

| Issue | Solution |
|-------|----------|
| App crashes on startup | Run `flutter clean && flutter pub get` |
| Music not playing | Check internet and URL validity |
| Notifications not showing | Grant permissions and check system settings |
| Weather not displaying | Check internet connection |
| TTS not working | Verify TTS engine installed |
| Animations laggy | Reduce snow intensity |
| Language not changing | Restart app after changing |

## 📞 Support

For issues:
1. Check SETUP_GUIDE.md
2. Check FEATURES.md
3. Review relevant service code
4. Check Flutter documentation
5. Run `flutter doctor` to verify setup

---

**Last Updated**: December 2024
