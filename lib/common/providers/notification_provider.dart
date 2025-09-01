import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettings {
  final bool notificationsEnabled;
  final bool habitReminders;
  final bool dailyMotivation;
  final bool streakReminders;
  final bool weeklyReports;
  final String reminderTime;
  final String morningReminderTime;
  final String eveningReminderTime;
  final List<String> reminderDays;

  const NotificationSettings({
    this.notificationsEnabled = true,
    this.habitReminders = true,
    this.dailyMotivation = true,
    this.streakReminders = true,
    this.weeklyReports = true,
    this.reminderTime = '09:00',
    this.morningReminderTime = '08:00',
    this.eveningReminderTime = '20:00',
    this.reminderDays = const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
  });

  NotificationSettings copyWith({
    bool? notificationsEnabled,
    bool? habitReminders,
    bool? dailyMotivation,
    bool? streakReminders,
    bool? weeklyReports,
    String? reminderTime,
    String? morningReminderTime,
    String? eveningReminderTime,
    List<String>? reminderDays,
  }) {
    return NotificationSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      habitReminders: habitReminders ?? this.habitReminders,
      dailyMotivation: dailyMotivation ?? this.dailyMotivation,
      streakReminders: streakReminders ?? this.streakReminders,
      weeklyReports: weeklyReports ?? this.weeklyReports,
      reminderTime: reminderTime ?? this.reminderTime,
      morningReminderTime: morningReminderTime ?? this.morningReminderTime,
      eveningReminderTime: eveningReminderTime ?? this.eveningReminderTime,
      reminderDays: reminderDays ?? this.reminderDays,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'habitReminders': habitReminders,
      'dailyMotivation': dailyMotivation,
      'streakReminders': streakReminders,
      'weeklyReports': weeklyReports,
      'reminderTime': reminderTime,
      'morningReminderTime': morningReminderTime,
      'eveningReminderTime': eveningReminderTime,
      'reminderDays': reminderDays,
    };
  }

  factory NotificationSettings.fromMap(Map<String, dynamic> map) {
    return NotificationSettings(
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      habitReminders: map['habitReminders'] ?? true,
      dailyMotivation: map['dailyMotivation'] ?? true,
      streakReminders: map['streakReminders'] ?? true,
      weeklyReports: map['weeklyReports'] ?? true,
      reminderTime: map['reminderTime'] ?? '09:00',
      morningReminderTime: map['morningReminderTime'] ?? '08:00',
      eveningReminderTime: map['eveningReminderTime'] ?? '20:00',
      reminderDays: List<String>.from(map['reminderDays'] ?? ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']),
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationSettings> {
  NotificationNotifier() : super(const NotificationSettings()) {
    _loadSettings();
  }

  static const String _settingsKey = 'notification_settings';

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);
      
      if (settingsJson != null) {
        // load the basic notification enabled setting
        final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
        state = state.copyWith(notificationsEnabled: notificationsEnabled);
      }
    } catch (e) {
      // If loading fails, use default settings
      state = const NotificationSettings();
    }
  }

  Future<void> updateNotificationsEnabled(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
    await _saveSettings();
  }

  Future<void> updateHabitReminders(bool enabled) async {
    state = state.copyWith(habitReminders: enabled);
    await _saveSettings();
  }

  Future<void> updateDailyMotivation(bool enabled) async {
    state = state.copyWith(dailyMotivation: enabled);
    await _saveSettings();
  }

  Future<void> updateReminderTime(String time) async {
    state = state.copyWith(reminderTime: time);
    await _saveSettings();
  }

  Future<void> updateStreakReminders(bool enabled) async {
    state = state.copyWith(streakReminders: enabled);
    await _saveSettings();
  }

  Future<void> updateWeeklyReports(bool enabled) async {
    state = state.copyWith(weeklyReports: enabled);
    await _saveSettings();
  }

  Future<void> updateMorningReminderTime(String time) async {
    state = state.copyWith(morningReminderTime: time);
    await _saveSettings();
  }

  Future<void> updateEveningReminderTime(String time) async {
    state = state.copyWith(eveningReminderTime: time);
    await _saveSettings();
  }

  Future<void> updateReminderDays(List<String> days) async {
    state = state.copyWith(reminderDays: days);
    await _saveSettings();
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_enabled', state.notificationsEnabled);
      await prefs.setBool('habit_reminders', state.habitReminders);
      await prefs.setBool('daily_motivation', state.dailyMotivation);
      await prefs.setBool('streak_reminders', state.streakReminders);
      await prefs.setBool('weekly_reports', state.weeklyReports);
      await prefs.setString('reminder_time', state.reminderTime);
      await prefs.setString('morning_reminder_time', state.morningReminderTime);
      await prefs.setString('evening_reminder_time', state.eveningReminderTime);
      await prefs.setStringList('reminder_days', state.reminderDays);
    } catch (e) {
      // Handle save error 
    }
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationSettings>((ref) {
  return NotificationNotifier();
});
