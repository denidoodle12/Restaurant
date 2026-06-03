import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const String _keyDarkMode = 'is_dark_mode';
  static const String _keyDailyReminder = 'is_daily_reminder_active';

  Future<bool> get isDarkMode async {
    final prefs = await sharedPreferences;
    return prefs.getBool(_keyDarkMode) ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await sharedPreferences;
    await prefs.setBool(_keyDarkMode, value);
  }

  Future<bool> get isDailyReminderActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(_keyDailyReminder) ?? false;
  }

  Future<void> setDailyReminderActive(bool value) async {
    final prefs = await sharedPreferences;
    await prefs.setBool(_keyDailyReminder, value);
  }
}
