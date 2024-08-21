import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alarm_app/src/model/room_model.dart';
import 'http_request.dart';

class RoomRepository {
  final Http httpRequest;

  RoomRepository(this.httpRequest);

  //topicId를 입력할 경우 topicId에 해당하는 room 전부 가져옴, default는 방 전부를 가져옴
  Future<List<RoomModel>> getRoomList(List<int?>? topicIdList) async {
    String endpoint = '/room/list';

    if (topicIdList != null && topicIdList.isNotEmpty) {
      // null 값 제거 후 쉼표로 구분된 문자열 생성
      final filteredIds = topicIdList.where((id) => id != null).join(',');
      endpoint += '?topicId=$filteredIds';
    }

    // httpRequest.get이 실제 GET 요청을 보내는 메소드라고 가정합니다.
    final response = await httpRequest.get(endpoint);

    // 응답이 리스트 형식으로 올 것으로 가정하고 이를 RoomModel 리스트로 변환
    return (response as List)
        .map((roomJson) => RoomModel.fromJson(roomJson as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> createRoom(RoomModel roomModel) async {
    final response = await httpRequest.post('/room/create', roomModel.toJson());
    return response;
  }

  Future<List<Map<String, dynamic>>> getTopicList() async {
    final response = await httpRequest.get('/topic/list');
    return (response as List)
        .map((topic) => topic as Map<String, dynamic>)
        .toList();
  }

  //수정
  Future<List<RoomModel>> getRoomListByIds(List<String> roomIds) async {
    final response = await httpRequest.post('/room/ids', {'roomIds': roomIds});
    return (response as List).map((json) => RoomModel.fromJson(json)).toList();
  }
}
