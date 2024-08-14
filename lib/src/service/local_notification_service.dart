import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

///왜 late로 하셨지? 페이로드가 뭘 의미하는거지?
///초기화가 복잡한 경우 late로 해야함 + 메모리 효율은 덤 비동기면 생성하는 시점에서 처리가 안되니 late키워드를 사용해서 받음.
///페이로드는 알람을 눌렀을 때 추가로 얻어올 데이터
/// 타임존 데이터 초기화
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
    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(scheduledDateTime, tz.local);

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
  }

  ///예약 취소
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
