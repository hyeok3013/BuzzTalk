import 'dart:convert';
import 'package:alarm_app/src/repository/http_request.dart' as http;
import 'package:alarm_app/src/model/msg_model.dart';

class MsgRepository {
  final Http httpRequest;

  MsgRepository(this.httpRequest);

  // 회원가입
  Future<void> register(String playerId, String password) async {
    await httpRequest.post('/player/register', {
      'playerId': playerId,
      'password': password,
    });
  }

  // 로그인
  Future<void> login(String playerId, String password) async {
    await httpRequest.post('/player/login', {
      'playerId': playerId,
      'password': password,
    });
  }

  // 비밀번호 변경
  Future<void> changePassword(
      String playerId, String oldPassword, String newPassword) async {
    await httpRequest.post('/player/change-password', {
      'playerId': playerId,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
  }

  // 회원 탈퇴
  Future<void> deletePlayer(String playerId, String password) async {
    await httpRequest.post('/player/delete', {
      'playerId': playerId,
      'password': password,
    });
  }
}
