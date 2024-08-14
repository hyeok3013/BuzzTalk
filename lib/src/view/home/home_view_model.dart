import 'package:alarm_app/src/view/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  int currentIndex = 0;

  void onTap(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
