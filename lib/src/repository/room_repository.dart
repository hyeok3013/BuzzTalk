import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alarm_app/src/model/room_model.dart';
import 'http_request.dart';

class RoomRepository {
  final Http httpRequest;

  RoomRepository(this.httpRequest);

  Future<List<RoomModel>> getRoomList({
    List<int>? topicIds,
    int? limit,
    int? cursorId,
  }) async {
    final body = {
      'topicIds': topicIds,
      'limit': limit ?? 5,
      'cursorId': cursorId,
    };

    final response = await httpRequest.post('/room/getList', body);
    if (response['result'] == true) {
      final rooms = response['data']['rooms'] as List;
      return rooms
          .map((roomJson) =>
              RoomModel.fromJson(roomJson as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load room list: ${response['errNum']}');
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
      throw Exception('Failed to load topics: ${response['errNum']}');
    }
  }
}
