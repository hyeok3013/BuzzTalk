import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alarm_app/src/model/topic_model.dart';
import 'http_request.dart';

class TopicRepository {
  final Http httpRequest;

  TopicRepository(this.httpRequest);

  // 주제 목록 가져오기
  Future<List<dynamic>> getTopicList() async {
    final response = await httpRequest.get('/topic/list');
    return response as List<dynamic>;
  }

  // 주제별 방의 개수 가져오기
  Future<Map<String, dynamic>> getRoomCountByTopic() async {
    final response = await httpRequest.get('/topic/room-count');
    return response;
  }
}
