import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:task_management/src/features/task/domain/task.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService();

  init() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_notification');

    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  getAndroidNotificationDetails() {
    return const AndroidNotificationDetails(
      'reminder',
      'Reminder Notification',
      channelDescription: 'Notification sent as reminder',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      category: AndroidNotificationCategory.reminder,
      icon: '@mipmap/ic_notification',
      groupKey: 'dev.mml.task.REMINDER',
    );
  }

  getIosNotificationDetails() {
    return const DarwinNotificationDetails();
  }

  getNotificationDetails() {
    return NotificationDetails(
      android: getAndroidNotificationDetails(),
      iOS: getIosNotificationDetails(),
    );
  }

  Future scheduleNotification(TaskModel reminder) async {
    if (reminder.dueDate != null) {
      flutterLocalNotificationsPlugin.zonedSchedule(
        reminder.key,
        'Reminder :${reminder.title}',
        reminder.description,
        notificationTime(reminder.dueDate!).add(const Duration(seconds: 5)),
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        getNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      debugPrint('notification set at ${reminder.dueDate}');
    } else {
      return;
    }
  }

  Future<bool> reminderHasNotification(TaskModel reminderTask) async {
    var pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications
        .any((notification) => notification.id == reminderTask.key);
  }

  void updateNotification(TaskModel reminder) async {
    var hasNotification = await reminderHasNotification(reminder);
    if (hasNotification) {
      flutterLocalNotificationsPlugin.cancel(reminder.key);
    }

    scheduleNotification(reminder);
  }

  void cancelNotification(int id) {
    flutterLocalNotificationsPlugin.cancel(id);
    debugPrint('$id canceled');
  }

  tz.TZDateTime notificationTime(DateTime dateTime) {
    return tz.TZDateTime(
        tz.local,
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
        dateTime.millisecond,
        dateTime.microsecond);
  }
}
