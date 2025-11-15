# Christmas Countdown App - Setup Guide

## Prerequisites

- Flutter SDK 3.6.0 or higher
- Dart SDK (included with Flutter)
- Android Studio or Xcode (for mobile development)
- Git

## Installation Steps

### 1. Clone the Repository
```bash
git clone <repository-url>
cd legendary-train
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the App

#### On Android
```bash
flutter run -d android
```

#### On iOS
```bash
flutter run -d ios
```

#### On Web (if configured)
```bash
flutter run -d web
```

## Configuration

### Custom Music URL
1. Visit [JukeHost.co.uk](https://jukehost.co.uk)
2. Upload your Christmas music file
3. Copy the direct link
4. Paste in Settings → Custom Music URL

### Weather API Integration (Optional)
To integrate real weather data:

1. Get an API key from [OpenWeatherMap](https://openweathermap.org/api)
2. Update `lib/services/weather_service.dart`:
```dart
final response = await http.get(Uri.parse(
  'https://api.openweathermap.org/data/2.5/weather?q=London&appid=YOUR_API_KEY&units=metric'
));
```

### Notification Permissions
The app will request notification permissions on first launch. Grant permissions to receive:
- 7 days before Christmas
- 3 days before Christmas
- 1 day before Christmas

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── theme.dart                         # Theme configuration
├── models/
│   ├── user_preferences_model.dart   # User settings
│   ├── theme_model.dart              # Theme definitions
│   ├── custom_event_model.dart       # Custom events
│   └── gift_model.dart               # Gift planner
├── services/
│   ├── preferences_service.dart      # Settings storage
│   ├── countdown_service.dart        # Countdown logic
│   ├── notification_service.dart     # Notifications
│   ├── music_service.dart            # Audio playback
│   ├── weather_service.dart          # Weather data
│   ├── accessibility_service.dart    # Accessibility
│   ├── custom_events_service.dart    # Custom events
│   ├── gift_planner_service.dart     # Gift management
│   ├── holiday_facts_service.dart    # Daily facts
│   ├── text_to_speech_service.dart   # TTS
│   ├── haptics_service.dart          # Haptic feedback
│   └── home_widget_service.dart      # Widget updates
├── screens/
│   ├── home_screen.dart              # Main countdown screen
│   ├── onboarding_screen.dart        # Tutorial
│   └── custom_events_screen.dart     # Custom events
├── widgets/
│   ├── snowfall_animation.dart       # Snow effect
│   ├── sparkle_particles.dart        # Sparkles
│   ├── santa_sleigh_animation.dart   # Santa animation
│   ├── confetti_animation.dart       # Confetti
│   ├── christmas_tree_widget.dart    # Tree decoration
│   ├── gift_boxes_widget.dart        # Gift boxes
│   ├── countdown_timer_widget.dart   # Timer display
│   ├── progress_circle_widget.dart   # Progress ring
│   ├── holiday_quote_widget.dart     # Quotes
│   ├── music_controls_widget.dart    # Music buttons
│   ├── weather_widget.dart           # Weather display
│   ├── settings_drawer.dart          # Settings menu
│   ├── gift_planner_widget.dart      # Gift planner
│   └── accessibility_settings_widget.dart  # Accessibility
└── localization/
    └── app_localizations.dart        # Multi-language support
```

## Features Overview

### Core Features
- ✅ Countdown timer with animations
- ✅ 9 customizable themes
- ✅ Snowfall and sparkle effects
- ✅ Santa sleigh animation
- ✅ Christmas tree decoration (Dec 24-25)
- ✅ Confetti celebration on Christmas
- ✅ Gift boxes animation
- ✅ Progress circle indicator

### Customization
- ✅ Year selector (current to +35 years)
- ✅ Theme selector with 9 options
- ✅ Snow intensity control (0-100%)
- ✅ Music volume control (0-100%)
- ✅ Custom music URL support
- ✅ Language selector (4 languages)

### Audio & Notifications
- ✅ Background music with default track
- ✅ Text-to-speech functionality
- ✅ Local notifications (7 days, 3 days, 1 day before)
- ✅ Custom notification messages

### Additional Features
- ✅ Weather display
- ✅ Daily holiday facts
- ✅ Daily inspirational messages
- ✅ Custom events countdown
- ✅ Gift planner with tracking
- ✅ Accessibility settings
- ✅ Home screen widgets
- ✅ Share functionality

## Troubleshooting

### App Won't Start
```bash
flutter clean
flutter pub get
flutter run
```

### Music Not Playing
- Check internet connection
- Verify custom music URL is valid
- Check volume settings
- Ensure audio permissions are granted

### Notifications Not Working
- Grant notification permissions
- Check system notification settings
- Ensure device time is correct

### Weather Not Displaying
- Check internet connection
- Verify location services are enabled
- Check weather API configuration

### Accessibility Features Not Working
- Verify TTS engine is installed
- Check accessibility permissions
- Restart the app

## Building for Release

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Performance Tips

1. **Reduce Snow Intensity**: Lower values improve performance
2. **Disable Animations**: Use reduced motion mode for older devices
3. **Close Background Apps**: Free up system resources
4. **Update Flutter**: Keep Flutter SDK updated

## Support & Feedback

For issues or feature requests, please:
1. Check existing issues
2. Provide detailed reproduction steps
3. Include device and OS information
4. Attach screenshots if applicable

## License

This project is licensed under the MIT License - see LICENSE file for details.

## Changelog

### Version 1.0.0 (December 2024)
- Initial release
- All core features implemented
- 9 themes included
- Multi-language support
- Accessibility features
- Custom events
- Gift planner
- Weather integration
- Daily facts and messages

---

**Happy Holidays! 🎄**
