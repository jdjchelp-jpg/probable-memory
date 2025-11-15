# Christmas Countdown App - Architecture

## Overview
A festive Christmas countdown mobile application with smooth animations, customizable themes, and magical holiday atmosphere.

## Core Features
1. **Countdown Timer** - Real-time countdown to Christmas with days, hours, minutes, seconds
2. **9 Beautiful Themes** - Customizable color themes (Classic, Winter, Royal, Candy, Golden, Icy, Forest, Sunset, Aurora)
3. **Animations** - Snowfall, sparkles, Santa sleigh, confetti, gift boxes, Christmas tree decoration
4. **Multi-language Support** - English, Spanish, French, Dutch
5. **Background Music** - Default holiday music with volume control and custom URL support
6. **Push Notifications** - Local notifications at 1 week, 3 days, 1 day before Christmas
7. **Data Persistence** - Save user preferences locally
8. **Special December 24-25 Feature** - Animated Christmas tree that decorates over 24 hours

## Technical Architecture

### Data Models (lib/models/)
- `user_preferences_model.dart` - Store user settings (theme, year, snow intensity, music, language, notifications)
- `theme_model.dart` - Theme configuration with colors and gradients
- `quote_model.dart` - Holiday quotes structure
- `notification_settings_model.dart` - Notification preferences and custom messages

### Services (lib/services/)
- `preferences_service.dart` - Handle local storage using shared_preferences
- `countdown_service.dart` - Calculate countdown values and special date logic
- `notification_service.dart` - Schedule and manage local notifications
- `music_service.dart` - Handle background music playback
- `quotes_service.dart` - Manage holiday quotes rotation
- `theme_service.dart` - Theme configurations and management

### Localization (lib/localization/)
- `app_localizations.dart` - Translation strings for all supported languages

### Screens (lib/screens/)
- `home_screen.dart` - Main countdown display with all animations

### Widgets (lib/widgets/)
- `countdown_timer_widget.dart` - Display countdown in frosted glass cards
- `snowfall_animation.dart` - Animated snowflakes
- `sparkle_particles.dart` - Floating sparkle particles
- `santa_sleigh_animation.dart` - Flying Santa across screen
- `confetti_animation.dart` - Christmas Day celebration
- `christmas_tree_widget.dart` - Animated decorating tree (Dec 24-25)
- `gift_boxes_widget.dart` - Bouncing gift boxes at bottom
- `progress_circle_widget.dart` - Circular progress indicator
- `settings_drawer.dart` - Side drawer with all settings
- `music_controls_widget.dart` - Play/pause/volume controls
- `holiday_quote_widget.dart` - Rotating inspirational quotes

### Theme (lib/theme.dart)
- Update with festive colors for all 9 themes
- Define gradients and card styles

## Implementation Flow
1. Set up dependencies (shared_preferences, audioplayers, flutter_local_notifications, confetti, etc.)
2. Create data models with toJson/fromJson
3. Implement services for data persistence, countdown logic, notifications, music
4. Create localization system for 4 languages
5. Build animation widgets (snowfall, sparkles, Santa, confetti, tree, gifts)
6. Build main countdown UI with timer cards
7. Implement settings drawer with all controls
8. Add progress circle and quotes rotation
9. Implement special Dec 24-25 tree decoration logic
10. Add background music with controls
11. Set up local notifications
12. Test and debug all features

## Key Technical Notes
- Auto-rollover to next year at Dec 26 midnight
- Tree appears Dec 24 midnight, decorates over 24h, disappears Dec 26 midnight
- Progress circle shows year completion percentage
- Quotes rotate every 8 seconds
- Santa flies across every 60 seconds
- All preferences persist across app launches
- Notification permissions requested when user enables notifications
