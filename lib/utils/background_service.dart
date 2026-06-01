import 'dart:math';
import 'dart:ui';

import 'package:workmanager/workmanager.dart';

import '../data/api/api_service.dart';
import 'notification_helper.dart';

class BackgroundService {
  static const String dailyReminderTask = 'dailyReminderTask';
  static const String dailyReminderUniqueName = 'restaurant-daily-reminder';

  Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  Future<void> scheduleDailyReminder() async {
    await Workmanager().registerPeriodicTask(
      dailyReminderUniqueName,
      dailyReminderTask,
      frequency: const Duration(hours: 24),
      initialDelay: _initialDelayUntil11AM(),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }

  Future<void> cancelDailyReminder() async {
    await Workmanager().cancelByUniqueName(dailyReminderUniqueName);
  }

  Duration _initialDelayUntil11AM() {
    final now = DateTime.now();
    var scheduled = DateTime(now.year, now.month, now.day, 11, 0);
    if (scheduled.isBefore(now) || scheduled.isAtSameMomentAs(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled.difference(now);
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    DartPluginRegistrant.ensureInitialized();

    if (task != BackgroundService.dailyReminderTask) {
      return Future.value(true);
    }

    try {
      final notificationHelper = NotificationHelper();
      await configureLocalTimezone();
      await notificationHelper.init();

      final apiService = ApiService();
      final response = await apiService.getRestaurantList();
      final restaurants = response.restaurants;

      if (restaurants.isEmpty) {
        return Future.value(true);
      }

      final randomIndex = Random().nextInt(restaurants.length);
      final restaurant = restaurants[randomIndex];

      await notificationHelper.showRestaurantNotification(restaurant);
      return Future.value(true);
    } catch (_) {
      return Future.value(false);
    }
  });
}
