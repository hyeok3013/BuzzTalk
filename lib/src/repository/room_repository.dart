import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alarm_app/src/model/room_model.dart';
import 'http_request.dart';

class RoomRepository {
  final Http httpRequest;

  RoomRepository(this.httpRequest);

  //topicId를 입력할 경우 topicId에 해당하는 room 전부 가져옴, default는 방 전부를 가져옴
  Future<List<RoomModel>> getRoomList(int? topicId) async {
    String endpoint = '/room/list';
    if (topicId != null) {
      endpoint += '?topicId=$topicId';
    }

    final response = await httpRequest.get(endpoint);

    return (response as List)
        .map((roomJson) => RoomModel.fromJson(roomJson as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> createRoom(RoomModel roomModel) async {
    final response = await httpRequest.post('/room/create', roomModel.toJson());
    return response;
  }

  //수정
  Future<List<RoomModel>> getRoomListByIds(List<String> roomIds) async {
    final response = await httpRequest.post('/room/ids', {'roomIds': roomIds});
    return (response as List).map((json) => RoomModel.fromJson(json)).toList();
  }
}
