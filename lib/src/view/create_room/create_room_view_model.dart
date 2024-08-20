import 'package:flutter/material.dart';
import 'package:alarm_app/src/model/room_model.dart';
import 'package:alarm_app/src/repository/room_repository.dart';

class CreateRoomViewModel extends ChangeNotifier {
  final RoomRepository _roomRepository;

  CreateRoomViewModel(this._roomRepository);

  Future<void> createRoom({
    required String roomName,
    required int topicId,
    DateTime? selectedTime, // 선택적, 사용자가 입력하지 않으면 서버에서 처리
  }) async {
    RoomModel roomModel = RoomModel(
      roomName: roomName,
      topicId: topicId,
      startTime: selectedTime,
    );

    try {
      await _roomRepository.createRoom(roomModel);
      print("Room Created.");
    } catch (e) {
      print("Failed: $e");
    }
  }
}
