import 'package:alarm_app/src/model/auth_model.dart';
import 'package:alarm_app/src/repository/socket_repository.dart';
import 'package:alarm_app/src/view/base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:alarm_app/src/model/room_model.dart'; // RoomModel 임포트

class ChatViewModel extends BaseViewModel {
  final SocketRepository socketRepository; // SocketRepository 인스턴스
  final RoomModel roomModel; // RoomModel 인스턴스
  final AuthModel authModel;
  List<Map<String, dynamic>> messages =
      []; // 메시지와 ID를 함께 저장하는 리스트 (내 메시지와 상대 메시지를 구분하기 위해 id도 함께 저장)  isMine 때문에 dynamic으로 변경

  final TextEditingController controller = TextEditingController();

  // 생성자에서 SocketRepository와 RoomModel을 주입받음
  ChatViewModel({
    required this.socketRepository,
    required this.roomModel,
    required this.authModel,
  }) {
    // 생성 시 소켓 연결 초기화
    final playerId = roomModel.playerId ?? ''; // Null 체크 및 기본값 설정
    final roomId = roomModel.roomId?.toString() ?? ''; // Null 체크 및 기본값 설정

    if (playerId.isNotEmpty && roomId.isNotEmpty) {
      socketRepository.initSocket(playerId as AuthModel);
      // 방에 접속
      socketRepository.joinRoom(roomId as int, playerId);

      // 메시지 수신 리스너 등록
      socketRepository.socket.on('msg', (data) {
        addMessage(data['msg'], data['playerId']);
      });
    }
  }
  // 메시지를 리스트에 추가하고 UI 업데이트 알림
  void addMessage(String message, String senderId) {
    bool isMine = senderId == authModel.playerId; // 메시지 보낸 사람이 나인지 확인
    messages.add({'message': message, 'playerId': senderId, 'isMine': isMine});
    notifyListeners();
  }

  // 메시지 전송 메서드
  void sendMessage() {
    if (controller.text.isNotEmpty) {
      final message = controller.text;
      final playerId = roomModel.playerId ?? '';
      final roomId = roomModel.roomId?.toString() ?? '';
      if (playerId.isNotEmpty && roomId.isNotEmpty) {
        socketRepository.sendMessage(roomId as int, message, playerId);
        controller.clear();
      }
    }
  }

  // addMessage(message, roomModel.playerId); // 내 메시지로 추가

  // 방에서 나가기
  void exitRoom() {
    final roomId = roomModel.roomId?.toString() ?? '';
    if (roomId.isNotEmpty) {
      socketRepository.exitRoom(roomId as int);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    socketRepository.dispose(); // 소켓 리소스 정리
    controller.dispose(); // 텍스트 필드 컨트롤러 정리
    super.dispose();
  }
}
