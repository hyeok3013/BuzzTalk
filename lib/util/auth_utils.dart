import 'package:flutter/material.dart';

class AuthUtils {
  // 영어 소문자와 숫자만 포함된 패턴, 최소 3자 이상, 최대 15자 이하
  bool isValidPlayerId(String playerId) {
    return RegExp(r'^[a-z0-9]{3,15}$').hasMatch(playerId);
  }

  // 최소 8자, 대문자, 소문자, 숫자, 특수문자를 각각 최소 하나씩 포함
  bool isValidPassword(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  // 에러 다이얼로그 표시 메서드
  void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
