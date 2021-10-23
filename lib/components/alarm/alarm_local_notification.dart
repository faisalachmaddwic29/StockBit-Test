import 'dart:convert';

import 'package:alarm/components/alarm/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// IOS
IOSNotificationDetails _iosPlatformChannelSpesifics =
    const IOSNotificationDetails(
  sound: "alarm_test.mp3",
  presentAlert: true,
  presentBadge: true,
  presentSound: true,
);
// END IOS

// ANDROID
AndroidNotificationDetails _androidPlatformChannelSpesifics =
    const AndroidNotificationDetails(
  "alarm_notif",
  'Change Alarm for notification',
  sound: RawResourceAndroidNotificationSound("alarm_test"),
  playSound: true,
  importance: Importance.max,
  priority: Priority.high,
  // fullScreenIntent: true,
);
// END ANDROID

class AlarmNotificationService {
  static final notifications = FlutterLocalNotificationsPlugin();

  static Future init(
      {bool initScheduled = false, required onSelectNotification}) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int? id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notifications.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  static Future _notificationsDetails() async {
    return NotificationDetails(
      android: _androidPlatformChannelSpesifics,
      iOS: _iosPlatformChannelSpesifics,
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    await notifications.show(id, title, body, await _notificationsDetails(),
        payload: payload);
  }

  static Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  static Future<void> scheduleNotification(
      {required DateTime dateTime, required AlarmModel alarmModel}) async {
    await _configureLocalTimeZone();
    var tzDateTime = tz.TZDateTime.from(dateTime, tz.local);

    await notifications.zonedSchedule(
      alarmModel.id ?? 0,
      alarmModel.title,
      alarmModel.alarmDateTime.toString(),
      tzDateTime,
      await _notificationsDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: jsonEncode(alarmModel.toMap()),
    );
  }

  static Future<void> cancelNotification({required int? id}) async {
    await notifications.cancel(id ?? 0);
  }
}
