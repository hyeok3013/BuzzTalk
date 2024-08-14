import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatViewModel with ChangeNotifier {
  List<String> mymessage = [];

  final TextEditingController controller = TextEditingController();
  void sendMessage() {
    if (controller.text.isNotEmpty) {
      mymessage.add(controller.text);
      controller.clear(); // 메시지 전송 후 입력창 비우기
    }
    notifyListeners();
  }
}
