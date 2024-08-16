import 'dart:convert';

import 'package:alarm_app/main.dart';
import 'package:alarm_app/src/repository/room_repository.dart';
import 'package:alarm_app/src/service/local_notification_service.dart';
import 'package:alarm_app/src/view/base_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:alarm_app/src/model/room_model.dart';
import 'package:flutter/cupertino.dart';

class RoomListViewModel extends BaseViewModel {
  final RoomRepository roomRepository;
  final LocalNotificationService localNotificationService;
  List<RoomModel> roomList = [
    RoomModel(
      roomId: '테스트 방 1',
      startTime: DateTime.now().add(Duration(seconds: 30)),
      endTime: DateTime.now(),
      topicId: 101,
      playerId: '1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    RoomModel(
      roomId: '테스트 방 2',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      topicId: 102,
      playerId: '2',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ]; // 방 목록을 저장할 리스트

  RoomListViewModel({
    required this.roomRepository,
    required this.localNotificationService,
  });

  // 방 목록을 서버에서 가져오는 메서드
  Future<void> roomListFetch() async {
    roomList =
        await roomRepository.getRoomList(101, 'null', 20); // 서버에서 방 목록 가져오기
    notifyListeners();
  }

  Future<void> createRoom() async {
    await roomRepository.createRoom(
      '테스트 방 123',
      1023,
      '13',
      DateTime.now(),
      DateTime.now().add(Duration(seconds: 30)),
    );
    notifyListeners();
  }

  void bookScheduleChat(RoomModel room) {
    localNotificationService.scheduleNotification(
      id: room.topicId,
      title: room.roomId,
      body: '채팅이 시작되었습니다.',
      scheduledDateTime: room.startTime,
    );
  }

  void cancleScheduleChat(RoomModel room) {
    localNotificationService.cancelNotification(room.hashCode);
  }
}
