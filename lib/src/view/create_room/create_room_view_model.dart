import 'package:flutter/material.dart';
import 'package:alarm_app/src/model/room_model.dart';
import 'package:alarm_app/src/repository/room_repository.dart';
import 'package:alarm_app/util/error_pop_util.dart';
import 'package:go_router/go_router.dart';

class CreateRoomViewModel extends ChangeNotifier {
  final RoomRepository _roomRepository;
  final ErrorPopUtils _errorPopUtil = ErrorPopUtils();

  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _topics = [];

  CreateRoomViewModel(this._roomRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get topics => _topics;

  Future<void> fetchTopics([BuildContext? context]) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _topics = await _roomRepository.getTopicList();
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch topics: $e';
    }
    notifyListeners();
  }

  Future<void> createRoom({
    required String roomName,
    required int topicId,
    DateTime? startTime,
    required DateTime endTime,
    required BuildContext context,
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

      if (response['result'] == true) {
        print("Room Created Successfully.");
        context.replace('/'); // 홈 화면으로 이동
      } else {
        _errorMessage = response['msg'] ?? '방 생성에 실패했습니다.';
        _errorPopUtil.showErrorDialog(context, '방 생성 실패', _errorMessage!);
      }
    } catch (e) {
      _errorMessage = '방 생성 중 오류가 발생했습니다.';
      _errorPopUtil.showErrorDialog(context, '오류', _errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
