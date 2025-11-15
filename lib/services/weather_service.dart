import 'package:flutter/foundation.dart';

class WeatherData {
  final String condition;
  final int temperature;
  final int humidity;
  final int windSpeed;
  final String icon;

  WeatherData({
    required this.condition,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
  });
}

class WeatherService {
  static final WeatherService _instance = WeatherService._internal();

  factory WeatherService() {
    return _instance;
  }

  WeatherService._internal();

  /// Get mock weather data for demonstration
  /// In production, integrate with OpenWeatherMap or similar API
  Future<WeatherData> getWeather() async {
    try {
      // Mock weather data - replace with actual API call
      // Example API integration:
      // final response = await http.get(Uri.parse(
      //   'https://api.openweathermap.org/data/2.5/weather?q=London&appid=$apiKey&units=metric'
      // ));
      
      return WeatherData(
        condition: 'Snowy',
        temperature: -2,
        humidity: 85,
        windSpeed: 15,
        icon: '❄️',
      );
    } catch (e) {
      if (kDebugMode) print('Weather error: $e');
      return WeatherData(
        condition: 'Clear',
        temperature: 5,
        humidity: 60,
        windSpeed: 10,
        icon: '⛅',
      );
    }
  }

  /// Get weather icon based on condition
  String getWeatherIcon(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('snow')) return '❄️';
    if (lower.contains('rain')) return '🌧️';
    if (lower.contains('cloud')) return '☁️';
    if (lower.contains('clear') || lower.contains('sunny')) return '☀️';
    if (lower.contains('wind')) return '💨';
    return '⛅';
  }

  /// Get weather description for accessibility
  String getWeatherDescription(WeatherData weather) {
    return '${weather.condition}, ${weather.temperature}°C, ${weather.humidity}% humidity, ${weather.windSpeed} km/h wind';
  }
}
