import 'package:alarm_app/src/view/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  int currentIndex = 0;
  List<int> selectedTopicIds = []; // 선택된 주제 ID 목록

  void onTap(int index) {
    currentIndex = index;
    notifyListeners();
  }

  // 필터된 주제 ID 목록 업데이트
  void updateSelectedTopics(List<int> topics) {
    selectedTopicIds = topics;
    notifyListeners();
  }
}
