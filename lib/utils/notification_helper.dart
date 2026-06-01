import 'dart:io';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../data/models/restaurant.dart';
import 'date_time_helper.dart';

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();
  factory NotificationHelper() => _instance;
  NotificationHelper._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'restaurant_app_channel';
  static const String _channelName = 'Daily Reminder';
  static const String _channelDesc =
      'Daily reminder to check restaurant recommendations';

  static const int dailyReminderId = 1001;

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    return true;
  }

  Future<void> scheduleDailyReminder({
    String title = 'Lunch Time!',
    String body = "It's 11 AM, time to find a great place to eat.",
  }) async {
    final scheduledDate = DateTimeHelper.nextInstanceOf(hour: 11, minute: 0);

    await _plugin.zonedSchedule(
      dailyReminderId,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> showRestaurantNotification(Restaurant restaurant) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        styleInformation: BigTextStyleInformation(
          'Lunch idea: ${restaurant.name} in ${restaurant.city} '
          '(${restaurant.rating} ★). Tap to see the details!',
          contentTitle: 'Lunch Time! 🍽️',
        ),
      ),
    );

    await _plugin.show(
      Random().nextInt(100000),
      'Lunch Time! 🍽️',
      'Try ${restaurant.name} in ${restaurant.city}',
      details,
      payload: restaurant.id,
    );
  }

  Future<void> cancelDailyReminder() async {
    await _plugin.cancel(dailyReminderId);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}

Future<void> configureLocalTimezone() async {
  tz_data.initializeTimeZones();
  try {
    final timeZoneName = DateTime.now().timeZoneName;
    tz.setLocalLocation(tz.getLocation(_resolveTimezone(timeZoneName)));
  } catch (_) {
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
  }
}

String _resolveTimezone(String name) {
  switch (name) {
    case 'WIB':
      return 'Asia/Jakarta';
    case 'WITA':
      return 'Asia/Makassar';
    case 'WIT':
      return 'Asia/Jayapura';
    default:
      return name;
  }
}
