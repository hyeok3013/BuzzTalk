import 'package:alarm_app/src/model/topic_model.dart';
import 'package:alarm_app/src/repository/topic_repository.dart';
import 'package:alarm_app/util/error_pop_util.dart';
import 'package:alarm_app/src/view/base_view_model.dart';
import 'package:flutter/cupertino.dart';

class TopicFilterViewModel extends BaseViewModel {
  final TopicRepository topicRepository;
  final ErrorPopUtils _errorPopUtil = ErrorPopUtils(); // ErrorPopUtils 추가

  TopicFilterViewModel({required this.topicRepository}) {
    loadTopics;
  }

  List<TopicModel> topics = [];
  List<int> selectedTopicIds = [];
  Map<int, int> topicRoomCounts = {}; // 각 주제별 방 개수

  // Topic과 방 개수 로드
  Future<void> loadTopics(BuildContext context) async {
    // BuildContext 추가
    try {
      topics = await topicRepository.getTopicList();
      topicRoomCounts = await topicRepository.getRoomCountByTopic();
    } catch (e) {
      _errorPopUtil.showErrorDialog(
          context, '로드 실패', '주제 목록이나 방 개수를 불러오는데 실패했습니다.');
      print('Failed to load topics or room counts: $e');
    }
    notifyListeners();
  }

  void onTopicTap(int topicId) {
    if (selectedTopicIds.contains(topicId)) {
      selectedTopicIds.remove(topicId);
    } else {
      selectedTopicIds.add(topicId);
    }
    notifyListeners();
  }
}
