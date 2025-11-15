class UserPreferencesModel {
  final int targetYear;
  final String themeId;
  final double snowIntensity;
  final double musicVolume;
  final String customMusicUrl;
  final bool notificationsEnabled;
  final String notificationOneWeek;
  final String notificationThreeDays;
  final String notificationOneDay;
  final String languageCode;
  final bool musicPlaying;
  final bool hasSeenOnboarding;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserPreferencesModel({
    required this.targetYear,
    required this.themeId,
    required this.snowIntensity,
    required this.musicVolume,
    required this.customMusicUrl,
    required this.notificationsEnabled,
    required this.notificationOneWeek,
    required this.notificationThreeDays,
    required this.notificationOneDay,
    required this.languageCode,
    required this.musicPlaying,
    required this.hasSeenOnboarding,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserPreferencesModel.defaults() {
    final now = DateTime.now();
    return UserPreferencesModel(
      targetYear: now.year,
      themeId: 'classic',
      snowIntensity: 50,
      musicVolume: 50,
      customMusicUrl: '',
      notificationsEnabled: false,
      notificationOneWeek: '',
      notificationThreeDays: '',
      notificationOneDay: '',
      languageCode: 'en',
      musicPlaying: false,
      hasSeenOnboarding: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  Map<String, dynamic> toJson() => {
    'targetYear': targetYear,
    'themeId': themeId,
    'snowIntensity': snowIntensity,
    'musicVolume': musicVolume,
    'customMusicUrl': customMusicUrl,
    'notificationsEnabled': notificationsEnabled,
    'notificationOneWeek': notificationOneWeek,
    'notificationThreeDays': notificationThreeDays,
    'notificationOneDay': notificationOneDay,
    'languageCode': languageCode,
    'musicPlaying': musicPlaying,
    'hasSeenOnboarding': hasSeenOnboarding,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    // Defensive parsing and type coercion to avoid runtime type errors
    bool _asBool(dynamic v, {bool defaultValue = false}) {
      if (v is bool) return v;
      if (v is String) return v.toLowerCase() == 'true' || v == '1';
      if (v is num) return v != 0;
      return defaultValue;
    }

    double _asDouble(dynamic v, {double defaultValue = 0}) {
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? defaultValue;
      return defaultValue;
    }

    int _asInt(dynamic v, {int defaultValue = 0}) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? defaultValue;
      return defaultValue;
    }

    String _asString(dynamic v, {String defaultValue = ''}) {
      if (v is String) return v;
      if (v == null) return defaultValue;
      return v.toString();
    }

    DateTime _asDateTime(dynamic v) {
      if (v is DateTime) return v;
      if (v is String) {
        try {
          return DateTime.parse(v);
        } catch (_) {}
      }
      return DateTime.now();
    }

    return UserPreferencesModel(
      targetYear: _asInt(json['targetYear'], defaultValue: DateTime.now().year),
      themeId: _asString(json['themeId'], defaultValue: 'classic'),
      snowIntensity: _asDouble(json['snowIntensity'], defaultValue: 50),
      musicVolume: _asDouble(json['musicVolume'], defaultValue: 50),
      customMusicUrl: _asString(json['customMusicUrl'], defaultValue: ''),
      notificationsEnabled: _asBool(json['notificationsEnabled'], defaultValue: false),
      notificationOneWeek: _asString(json['notificationOneWeek'], defaultValue: ''),
      notificationThreeDays: _asString(json['notificationThreeDays'], defaultValue: ''),
      notificationOneDay: _asString(json['notificationOneDay'], defaultValue: ''),
      languageCode: _asString(json['languageCode'], defaultValue: 'en'),
      musicPlaying: _asBool(json['musicPlaying'], defaultValue: false),
      hasSeenOnboarding: _asBool(json['hasSeenOnboarding'], defaultValue: false),
      createdAt: _asDateTime(json['createdAt']),
      updatedAt: _asDateTime(json['updatedAt']),
    );
  }

  UserPreferencesModel copyWith({
    int? targetYear,
    String? themeId,
    double? snowIntensity,
    double? musicVolume,
    String? customMusicUrl,
    bool? notificationsEnabled,
    String? notificationOneWeek,
    String? notificationThreeDays,
    String? notificationOneDay,
    String? languageCode,
    bool? musicPlaying,
    bool? hasSeenOnboarding,
  }) {
    return UserPreferencesModel(
      targetYear: targetYear ?? this.targetYear,
      themeId: themeId ?? this.themeId,
      snowIntensity: snowIntensity ?? this.snowIntensity,
      musicVolume: musicVolume ?? this.musicVolume,
      customMusicUrl: customMusicUrl ?? this.customMusicUrl,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationOneWeek: notificationOneWeek ?? this.notificationOneWeek,
      notificationThreeDays: notificationThreeDays ?? this.notificationThreeDays,
      notificationOneDay: notificationOneDay ?? this.notificationOneDay,
      languageCode: languageCode ?? this.languageCode,
      musicPlaying: musicPlaying ?? this.musicPlaying,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
