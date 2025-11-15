class CountdownService {
  DateTime getChristmasDate(int year) => DateTime(year, 12, 25);

  Map<String, int> getCountdown(int targetYear) {
    final now = DateTime.now();
    final christmas = getChristmasDate(targetYear);
    final difference = christmas.difference(now);

    if (difference.isNegative) {
      return {'days': 0, 'hours': 0, 'minutes': 0, 'seconds': 0};
    }

    return {
      'days': difference.inDays,
      'hours': difference.inHours % 24,
      'minutes': difference.inMinutes % 60,
      'seconds': difference.inSeconds % 60,
    };
  }

  bool isChristmasDay(int targetYear) {
    final now = DateTime.now();
    final christmas = getChristmasDate(targetYear);
    return now.year == christmas.year && 
           now.month == christmas.month && 
           now.day == christmas.day;
  }

  bool shouldShowTree(int targetYear) {
    final now = DateTime.now();
    return (now.year == targetYear && now.month == 12 && (now.day == 24 || now.day == 25));
  }

  double getTreeDecorationProgress(int targetYear) {
    final now = DateTime.now();
    if (now.year != targetYear || now.month != 12) return 0;
    
    if (now.day < 24) return 0;
    if (now.day > 25) return 0;
    
    final dec24Midnight = DateTime(targetYear, 12, 24);
    final dec25Midnight = DateTime(targetYear, 12, 25);
    
    if (now.isBefore(dec24Midnight)) return 0;
    if (now.isAfter(dec25Midnight) || now.isAtSameMomentAs(dec25Midnight)) return 100;
    
    final totalDuration = dec25Midnight.difference(dec24Midnight).inMilliseconds;
    final elapsed = now.difference(dec24Midnight).inMilliseconds;
    final progress = (elapsed / totalDuration * 100).clamp(0.0, 100.0);
    
    return progress.toDouble();
  }

  bool shouldAutoRollover(int currentTargetYear) {
    final now = DateTime.now();
    return now.year == currentTargetYear && now.month == 12 && now.day >= 26;
  }

  int getNextYear(int currentTargetYear) => currentTargetYear + 1;

  double getYearProgress(int targetYear) {
    final now = DateTime.now();
    final yearStart = DateTime(now.year, 1, 1);
    final christmas = getChristmasDate(targetYear);
    
    if (now.year != targetYear) {
      return now.year < targetYear ? 0 : 100;
    }
    
    final totalDays = christmas.difference(yearStart).inDays;
    final elapsedDays = now.difference(yearStart).inDays;
    
    return (elapsedDays / totalDays * 100).clamp(0, 100);
  }

  int getDaysUntilChristmas(int targetYear) {
    final countdown = getCountdown(targetYear);
    return countdown['days'] ?? 0;
  }
}
