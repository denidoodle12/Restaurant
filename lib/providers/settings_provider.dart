import 'package:flutter/foundation.dart';
import '../data/preferences/preferences_helper.dart';
import '../utils/background_service.dart';
import '../utils/notification_helper.dart';

class SettingsProvider extends ChangeNotifier {
  final PreferencesHelper preferencesHelper;
  final BackgroundService backgroundService;
  final NotificationHelper notificationHelper;

  SettingsProvider({
    required this.preferencesHelper,
    required this.backgroundService,
    required this.notificationHelper,
  }) {
    _loadSettings();
  }

  bool _isDailyReminderActive = false;
  bool get isDailyReminderActive => _isDailyReminderActive;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> _loadSettings() async {
    _isDailyReminderActive = await preferencesHelper.isDailyReminderActive;
    notifyListeners();
  }

  Future<void> setDailyReminder(bool enabled) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (enabled) {
        final granted = await notificationHelper.requestPermissions();
        if (!granted) {
          _errorMessage =
              'Notification permission denied. Please enable it in settings.';
          _isDailyReminderActive = false;
          _isLoading = false;
          notifyListeners();
          return;
        }
        await backgroundService.scheduleDailyReminder();
      } else {
        await backgroundService.cancelDailyReminder();
        await notificationHelper.cancelDailyReminder();
      }

      await preferencesHelper.setDailyReminderActive(enabled);
      _isDailyReminderActive = enabled;
    } catch (e) {
      _errorMessage = 'Failed to update reminder: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
