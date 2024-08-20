import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alarm_app/src/repository/http_request.dart';

class AuthRepository {
  final Http httpRequest;

  AuthRepository(this.httpRequest);

  // 회원가입
  Future<Map<String, dynamic>> register(
      String playerId, String password) async {
    final response = await httpRequest.post('/player/register', {
      'playerId': playerId,
      'password': password,
    });

    return response;
  }

  // 로그인
  Future<Map<String, dynamic>> login(String playerId, String password) async {
    final response = await httpRequest.post('/player/login', {
      'playerId': playerId,
      'password': password,
    });

    return response;
  }

//TODO: 서버 컨트롤러 수정
  // 비밀번호 변경
  Future<Map<String, dynamic>> changePassword(
      String oldPassword, String newPassword, String newPasswordCheck) async {
    final response = await httpRequest.post('/player/changePassword', {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'newPasswordCheck': newPasswordCheck,
    });

    return response;
  }

  // 회원 탈퇴
  // TODO: DELETE 메소드 사용하기
  Future<Map<String, dynamic>> deletePlayer() async {
    final response = await httpRequest.post('/player/delete', {});
    return response;
  }
}
