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
    final response = await httpRequest.get('/topic/roomCount');

    if (response['result'] == true) {
      final List<dynamic> responseData = response['data'] as List<dynamic>;
      return {
        for (var item in responseData)
          (item['topic_id'] as int): int.parse(item['room_count'] as String)
      };
    } else {
      throw Exception('Failed to load room count: ${response['msg']}');
    }
  }
}
