import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alarm_app/src/model/topic_model.dart';
import 'http_request.dart';

class TopicRepository {
  final Http httpRequest;

  TopicRepository(this.httpRequest);

  // 주제 목록 가져오기
  Future<List<TopicModel>> getTopicList() async {
    final response = await httpRequest.get('/topic/list');
    return (response as List)
        .map(
            (roomJson) => TopicModel.fromJson(roomJson as Map<String, dynamic>))
        .toList();
  }

  // 주제별 방의 개수 가져오기
// 주제별 방의 개수 가져오기
  Future<Map<int, int>> getRoomCountByTopic() async {
    final response = await httpRequest.get('/topic/room-count');

    // API 응답이 List 형태로 반환된다고 가정
    final List<dynamic> responseData = response as List<dynamic>;

    // 리스트의 각 항목을 Map<int, int>로 변환
    return {
      for (var item in responseData)
        (item['topic_id'] as int): int.parse(item['room_count'] as String)
    };
  }
}
