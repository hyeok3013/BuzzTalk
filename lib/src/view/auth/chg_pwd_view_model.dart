import 'package:flutter/material.dart';
import 'package:alarm_app/src/repository/auth_repository.dart';
import 'package:alarm_app/util/error_pop_util.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final ErrorPopUtils _errorPopUtil = ErrorPopUtils();

  ChangePasswordViewModel(this._authRepository);

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordCheck,
    required BuildContext context, // 추가된 BuildContext
  }) async {
    if (newPassword != newPasswordCheck) {
      _errorPopUtil.showErrorDialog(
          context, "비밀번호 변경 실패", "새 비밀번호가 일치하지 않습니다.");
      return;
    }

    try {
      final response = await _authRepository.changePassword(
          oldPassword, newPassword, newPasswordCheck);

      if (response['result'] == true) {
        // 성공 시 추가 작업
        print("Password changed successfully");
      } else {
        // 실패 시 서버에서 제공된 오류 메시지를 팝업으로 표시
        _errorPopUtil.showErrorDialog(
            context, "비밀번호 변경 실패", response['msg'] ?? "비밀번호 변경에 실패했습니다.");
      }
    } catch (e) {
      // 실패 시 팝업으로 에러 메시지 표시
      _errorPopUtil.showErrorDialog(
          context, "비밀번호 변경 실패", "오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
      print("Failed to change password: $e");
    }
  }
}
