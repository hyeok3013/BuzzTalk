import 'dart:convert';

import 'package:alarm_app/main.dart';
import 'package:alarm_app/src/repository/room_repository.dart';
import 'package:alarm_app/src/repository/shared_preferences_repository.dart';
import 'package:alarm_app/src/service/local_notification_service.dart';
import 'package:alarm_app/src/view/base_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:alarm_app/src/model/room_model.dart';
import 'package:flutter/cupertino.dart';

class RoomListViewModel extends BaseViewModel {
  final RoomRepository roomRepository;
  final LocalNotificationService localNotificationService;
  final SharedPreferencesRepository sharedPreferencesRepository;

  List<RoomModel> roomList = []; // 방 목록을 저장할 리스트
  bool isLoading = false; // 로딩 상태 관리
  bool hasMoreData = true; // 추가 데이터가 있는지 확인
  int? cursorId; // 커서 ID (마지막으로 가져온 방의 ID)
  final int limit = 5; // 한 번에 불러올 방의 개수

  RoomListViewModel({
    required this.roomRepository,
    required this.localNotificationService,
    required this.sharedPreferencesRepository,
  });

  // 서버에서 방 목록을 가져오는 메서드
  Future<void> roomListFetch(List<int>? topicIDList,
      {bool refresh = false}) async {
    // 이미 로딩 중이거나 추가로 가져올 데이터가 없으면 return
    if (isLoading || !hasMoreData) return;

    isLoading = true;
    notifyListeners(); // 로딩 중 상태를 UI에 반영

    if (refresh) {
      // 새로고침인 경우 기존 데이터를 초기화하고 cursorId 리셋
      roomList = [];
      cursorId = null; // 처음부터 다시 불러옴
      hasMoreData = true; // 다시 데이터가 있을 수 있음
    }

    try {
      // 서버에서 방 목록 가져오기 (커서 ID를 기준으로)
      final newRooms = await roomRepository.getRoomList(
        topicIds: topicIDList,
        limit: limit,
        cursorId: cursorId,
      );

      if (newRooms.isEmpty) {
        hasMoreData = false; // 더 이상 가져올 데이터가 없으면 false
      } else {
        // 방 목록을 기존 데이터에 추가
        roomList.addAll(newRooms);
        cursorId = newRooms.last.roomId; // 마지막 방 ID를 커서로 설정
      }

      // 각 방에 대한 예약 정보를 로컬에서 조회하여 설정
      for (RoomModel room in roomList) {
        bool isReserved = sharedPreferencesRepository.isReserved(room);
        room.book = isReserved;
      }
    } catch (e) {
      // 오류 처리
      print("방 목록 가져오기 실패: $e");
    } finally {
      isLoading = false;
      notifyListeners(); // 데이터 로딩이 끝났음을 UI에 알림
    }
  }

  void bookScheduleChat(RoomModel room) {
    localNotificationService.scheduleNotification(
        id: room.roomId!,
        title: room.roomName,
        body: '채팅이 시작되었습니다.',
        scheduledDateTime: room.startTime!,
        payload: room.roomId.toString());

    sharedPreferencesRepository.saveReservation(room);
    notifyListeners();
  }

  void cancelScheduleChat(RoomModel room) {
    localNotificationService.cancelNotification(room.roomId!);
    sharedPreferencesRepository.removeReservation(room);
    notifyListeners();
  }
}
