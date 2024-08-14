import 'package:alarm_app/main.dart';
import 'package:alarm_app/src/model/msg_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketRepository {
  late IO.Socket _socket;

  // 소켓 연결 설정(특정 플레이어 아이디에 대해 String으로 연결)
  void initSocket(String playerId) {
    _socket = IO.io(
      'http://localhost:3001/chat',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'playerId': playerId}) // playerId를 쿼리로 전송
          .enableAutoConnect()
          .build(),
    );

    // 연결, 혹은 디스커넥트시 알림
    _socket.onConnect((_) {
      print('connected to websocket server');
    });

    _socket.onDisconnect((_) {
      print('disconnected from websocket server');
    });

    // 메시지 수신(data.playerId,data.roomId,data.msg 값들 사용,dynamic 형태로 사용)
    _socket.on('msg', (data) {
      print('New message: $data');
    });

    // 사용자 목록 수신(data.room ,data.userList 값들 사용)
    _socket.on('userList', (data) {
      print('User List: ${data['userList']}');
    });
  }

  // 방에 접속
  void joinRoom(String roomId, String playerId) {
    _socket.emit('join', {'roomId': roomId, 'playerId': playerId});
  }

  // 방에서 나가기
  void exitRoom(String roomId) {
    _socket.emit('exit', {'roomId': roomId});
  }

  // 메시지 전송
  void sendMessage(String roomId, String msg, String playerId) {
    _socket.emit('msg', {'roomId': roomId, 'msg': msg, 'playerId': playerId});
  }

  // 특정 방의 사용자 목록 요청(방에 있는 모두에게 뿌려줌)
  void getUserList(String roomId) {
    _socket.emit('getUserList', roomId);
  }

  // 소켓 연결 해제
  void dispose() {
    _socket.dispose();
  }
}
