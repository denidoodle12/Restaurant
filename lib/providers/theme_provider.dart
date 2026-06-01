import 'package:flutter/material.dart';
import '../data/preferences/preferences_helper.dart';

class ThemeProvider extends ChangeNotifier {
  final PreferencesHelper preferencesHelper;

  ThemeProvider({required this.preferencesHelper}) {
    _loadTheme();
  }

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> _loadTheme() async {
    final isDark = await preferencesHelper.isDarkMode;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    _themeMode = newMode;
    await preferencesHelper.setDarkMode(newMode == ThemeMode.dark);
    notifyListeners();
  }

  Future<void> setDarkMode(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await preferencesHelper.setDarkMode(isDark);
    notifyListeners();
  }
}
