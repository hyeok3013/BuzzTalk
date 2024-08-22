import 'package:flutter/material.dart';
import 'package:alarm_app/src/model/room_model.dart';
import 'package:alarm_app/src/repository/room_repository.dart';
import 'package:go_router/go_router.dart';

class CreateRoomViewModel extends ChangeNotifier {
  final RoomRepository _roomRepository;

  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _topics = [];

  CreateRoomViewModel(this._roomRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get topics => _topics;

  Future<void> fetchTopics() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _topics = await _roomRepository.getTopicList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch topics: $e';
      notifyListeners();
    }
  }

  Future<void> createRoom({
    required String roomName,
    required int topicId,
    DateTime? startTime,
    required DateTime endTime,
    required BuildContext context, // 추가된 BuildContext
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    RoomModel roomModel = RoomModel(
      roomName: roomName,
      topicId: topicId,
      startTime: startTime,
      endTime: endTime,
    );

    try {
      final response = await _roomRepository.createRoom(roomModel);

      _isLoading = false;
      notifyListeners();

      if (response['status'] == 'success') {
        print("Room Created Successfully.");

        // 방 생성이 성공한 후 홈 화면으로 이동
        context.replace('/'); // 홈 화면으로 이동
      } else {
        _errorMessage = response['error'] ?? 'Room creation failed';
        notifyListeners();

        // 에러가 있을 경우 스낵바로 사용자에게 알림
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!)),
        );
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An error occurred: $e';
      notifyListeners();

      // 에러가 있을 경우 스낵바로 사용자에게 알림
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!)),
      );
    }
  }
}
