import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alarm_app/src/model/room_model.dart';
import 'http_request.dart';

class RoomRepository {
  final Http httpRequest;

  RoomRepository(this.httpRequest);

  //topicId를 입력할 경우 topicId에 해당하는 room 전부 가져옴, default는 방 전부를 가져옴

  Future<List<RoomModel>> getRoomList({
    List<int>? topicIds,
    int? limit,
    int? cursorId,
  }) async {
    final body = {
      'topicIds': topicIds,
      'limit': limit ?? 5, // limit을 설정 (기본값 5)
      'cursorId': cursorId, // 커서 ID 추가
    };

    final response = await httpRequest.post('/room/getList', body);
    if (response['result'] == true) {
      final rooms = response['data']['rooms'] as List;
      return rooms
          .map((roomJson) =>
              RoomModel.fromJson(roomJson as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load room list: ${response['msg']}');
    }
  }

  Future<Map<String, dynamic>> createRoom(RoomModel roomModel) async {
    final response = await httpRequest.post('/room/create', roomModel.toJson());
    return response;
  }

  Future<List<Map<String, dynamic>>> getTopicList() async {
    final response = await httpRequest.get('/topic/list');
    if (response['result'] == true) {
      return (response['data'] as List)
          .map((topic) => topic as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Failed to load topics: ${response['msg']}');
    }
  }

  //수정
  Future<List<RoomModel>> getRoomListByIds(List<String> roomIds) async {
    final response =
        await httpRequest.post('/room/getListByIds', {'roomIds': roomIds});
    return (response as List).map((json) => RoomModel.fromJson(json)).toList();
  }
}
