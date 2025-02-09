import 'dart:io';

import 'package:alarm_app/util/helper/route.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class LocalNotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  LocalNotificationService() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        print("Received notification: $title, $body, $payload");
      },
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
      print("Notification clicked ${notificationResponse.payload}");
      // GoRouter.of(rootNavigatorKey.currentContext!).go('/chat');
    }
        // onDidReceiveBackgroundNotificationResponse:

        );

    if (Platform.isAndroid) {
      final androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      // Android 13 이상에서 알림 권한 요청
      androidImplementation?.requestPermission();
    }

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
  }

  ///예약 알람 기능
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
    String? payload,
  }) async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
        scheduledDateTime.subtract(const Duration(hours: 9)), tz.local);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'default_channel_id', 'Default Notifications',
            channelDescription: 'General notifications for the app',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true);

    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id, // Notification ID
        title,
        body,
        scheduledDate,
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload);

    print(scheduledDate);
    print('현재시각');
    print(tz.local);
    print(tz.TZDateTime.now(tz.local)); // 로컬 시간대의 현재 시각

    print(DateTime.now());
    print(scheduledDate.isBefore(DateTime.now())); // 예약 시간이 현재보다 이전인지 확인

// 시간 차이를 계산하고 출력
    final difference = scheduledDate.difference(DateTime.now());
    print('Difference in hours: ${difference.inHours} hours');
    print(
        'Difference in minutes: ${difference.inMinutes.remainder(60)} minutes');
  }

  /// 특정 ID의 알림 취소
  Future<void> cancelNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
