// TODO: 에러 처리 하기
import 'package:flutter/material.dart';
import 'package:alarm_app/src/repository/auth_repository.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  ChangePasswordViewModel(this._authRepository);

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordCheck,
  }) async {
    if (newPassword != newPasswordCheck) {
      throw Exception("New passwords do not match");
    }

    try {
      await _authRepository.changePassword(
          oldPassword, newPassword, newPasswordCheck);
      // 성공 시 추가 작업
      print("Password changed successfully");
    } catch (e) {
      // 실패 시 추가 작업
      print("Failed to change password: $e");
      rethrow;
    }
  }
}
