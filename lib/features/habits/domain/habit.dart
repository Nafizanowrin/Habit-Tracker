import 'package:uuid/uuid.dart';

class Habit {
  final String id;
  final String userId;
  final String title;
  final String description;
  final HabitFrequency frequency;
  final HabitCategory category;
  final DateTime createdAt;
  final DateTime? lastCompletedAt;
  final int streakCount;
  final int longestStreak;
  final bool isActive;
  final List<DateTime> completedDates;
  final String? icon;
  final String? color;

  const Habit({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.frequency,
    required this.category,
    required this.createdAt,
    this.lastCompletedAt,
    this.streakCount = 0,
    this.longestStreak = 0,
    this.isActive = true,
    this.completedDates = const [],
    this.icon,
    this.color,
  });

  factory Habit.create({
    required String userId,
    required String title,
    required String description,
    required HabitFrequency frequency,
    required HabitCategory category,
    String? icon,
    String? color,
  }) {
    return Habit(
      id: const Uuid().v4(),
      userId: userId,
      title: title,
      description: description,
      frequency: frequency,
      category: category,
      createdAt: DateTime.now(),
      icon: icon,
      color: color,
    );
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      frequency: HabitFrequency.values.firstWhere(
        (e) => e.name == map['frequency'],
        orElse: () => HabitFrequency.daily,
      ),
      category: HabitCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => HabitCategory.others,
      ),
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
      lastCompletedAt: map['lastCompletedAt'] != null 
          ? DateTime.parse(map['lastCompletedAt']) 
          : null,
      streakCount: map['streakCount'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
      isActive: map['isActive'] ?? true,
      completedDates: map['completedDates'] != null
          ? (map['completedDates'] as List)
              .map((date) => DateTime.parse(date))
              .toList()
          : [],
      icon: map['icon'],
      color: map['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'frequency': frequency.name,
      'category': category.name,
      'createdAt': createdAt.toIso8601String(),
      'lastCompletedAt': lastCompletedAt?.toIso8601String(),
      'streakCount': streakCount,
      'longestStreak': longestStreak,
      'isActive': isActive,
      'completedDates': completedDates.map((date) => date.toIso8601String()).toList(),
      'icon': icon,
      'color': color,
    };
  }

  Habit copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    HabitFrequency? frequency,
    HabitCategory? category,
    DateTime? createdAt,
    DateTime? lastCompletedAt,
    int? streakCount,
    int? longestStreak,
    bool? isActive,
    List<DateTime>? completedDates,
    String? icon,
    String? color,
  }) {
    return Habit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      streakCount: streakCount ?? this.streakCount,
      longestStreak: longestStreak ?? this.longestStreak,
      isActive: isActive ?? this.isActive,
      completedDates: completedDates ?? this.completedDates,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  // Mark habit as completed
  Habit markCompleted() {
    final now = DateTime.now();
    final newStreakCount = _calculateNewStreakCount(now);
    final newLongestStreak = newStreakCount > longestStreak ? newStreakCount : longestStreak;
    final newCompletedDates = List<DateTime>.from(completedDates);
    
    // Add today's date if not already present
    if (!_isSameDay(now, newCompletedDates.isNotEmpty ? newCompletedDates.last : DateTime(1970))) {
      newCompletedDates.add(now);
    }
    
    return copyWith(
      lastCompletedAt: now,
      streakCount: newStreakCount,
      longestStreak: newLongestStreak,
      completedDates: newCompletedDates,
    );
  }

  // Calculate new streak count based on frequency and last completion
  int _calculateNewStreakCount(DateTime completionTime) {
    if (lastCompletedAt == null) return 1;
    
    final difference = completionTime.difference(lastCompletedAt!).inDays;
    
    switch (frequency) {
      case HabitFrequency.daily:
        return difference <= 1 ? streakCount + 1 : 1;
      case HabitFrequency.weekly:
        return difference <= 7 ? streakCount + 1 : 1;
      case HabitFrequency.monthly:
        return difference <= 30 ? streakCount + 1 : 1;
    }
  }

  // Check if habit is due today
  bool get isDueToday {
    if (lastCompletedAt == null) return true;
    
    final now = DateTime.now();
    final lastCompleted = lastCompletedAt!;
    
    switch (frequency) {
      case HabitFrequency.daily:
        return !_isSameDay(now, lastCompleted);
      case HabitFrequency.weekly:
        return now.difference(lastCompleted).inDays >= 7;
      case HabitFrequency.monthly:
        return now.difference(lastCompleted).inDays >= 30;
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Get completion percentage for current month
  double getMonthlyCompletionPercentage() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    
    int totalDays = lastDayOfMonth.day;
    int completedDays = completedDates.where((date) => 
      date.isAfter(firstDayOfMonth.subtract(const Duration(days: 1))) &&
      date.isBefore(lastDayOfMonth.add(const Duration(days: 1)))
    ).length;
    
    return totalDays > 0 ? (completedDays / totalDays) * 100 : 0.0;
  }

  // Check if habit was completed on a specific date
  bool isCompletedOnDate(DateTime date) {
    return completedDates.any((completedDate) => _isSameDay(completedDate, date));
  }

  // Get completion count for a specific month
  int getCompletionCountForMonth(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    
    return completedDates.where((date) => 
      date.isAfter(firstDayOfMonth.subtract(const Duration(days: 1))) &&
      date.isBefore(lastDayOfMonth.add(const Duration(days: 1)))
    ).length;
  }
}

enum HabitFrequency {
  daily,
  weekly,
  monthly,
}

enum HabitCategory {
  health,
  study,
  fitness,
  productivity,
  mentalHealth,
  others,
}

extension HabitCategoryExtension on HabitCategory {
  String get displayName {
    switch (this) {
      case HabitCategory.health:
        return 'Health';
      case HabitCategory.study:
        return 'Study';
      case HabitCategory.fitness:
        return 'Fitness';
      case HabitCategory.productivity:
        return 'Productivity';
      case HabitCategory.mentalHealth:
        return 'Mental Health';
      case HabitCategory.others:
        return 'Others';
    }
  }
  
  String get icon {
    switch (this) {
      case HabitCategory.health:
        return '🏥';
      case HabitCategory.study:
        return '📚';
      case HabitCategory.fitness:
        return '💪';
      case HabitCategory.productivity:
        return '⚡';
      case HabitCategory.mentalHealth:
        return '🧠';
      case HabitCategory.others:
        return '📝';
    }
  }
}
