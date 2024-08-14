import 'dart:convert';

import 'package:alarm_app/main.dart';
import 'package:alarm_app/src/repository/room_repository.dart';
import 'package:alarm_app/src/view/base_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:alarm_app/src/model/room_model.dart';
import 'package:flutter/cupertino.dart';

class RoomListViewModel extends BaseViewModel {
  final RoomRepository roomRepository;
  List<RoomModel> roomList = []; // 방 목록을 저장할 리스트

  RoomListViewModel({required this.roomRepository});

  // 방 목록을 서버에서 가져오는 메서드
  Future<void> roomListFetch() async {
    print('1');
    roomList =
        await roomRepository.getRoomList(null, null, 20); // 서버에서 방 목록 가져오기
    notifyListeners();

    print(roomRepository.getRoomList(null, null, 20));
  }

  Future<void> createRoom() async {
    await roomRepository.createRoom(
      '테스트 방 1',
      101,
      '1',
      DateTime.now(),
      DateTime.now().add(Duration(seconds: 30)),
    );
    notifyListeners();
  }
}
