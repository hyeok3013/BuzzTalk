import 'package:alarm_app/src/model/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:alarm_app/src/repository/auth_repository.dart';
import 'package:alarm_app/util/auth_utils.dart';
import 'package:alarm_app/util/error_pop_util.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginViewModel extends ChangeNotifier {
  String _playerId = '';
  String _password = '';
  bool _isLoading = false;
  bool _isObscureText = true;
  String? _playerIdError;
  String? _passwordError;

  final AuthRepository _authRepository;
  final AuthUtils _validator = AuthUtils();
  final ErrorPopUtils _errorPopUtil = ErrorPopUtils();

  LoginViewModel(this._authRepository);

  String get playerId => _playerId;
  String get password => _password;
  bool get isLoading => _isLoading;
  bool get isObscureText => _isObscureText;
  String? get playerIdError => _playerIdError;
  String? get passwordError => _passwordError;

  void updatePlayerId(String playerId) {
    _playerId = playerId;
    _playerIdError = null;
    notifyListeners();
  }

  void updatePassword(String password) {
    _password = password;
    _passwordError = null;
    notifyListeners();
  }

  void toggleObscureText() {
    _isObscureText = !_isObscureText;
    notifyListeners();
  }

  Future<void> signIn(BuildContext context) async {
    _isLoading = true;
    _playerIdError = null;
    _passwordError = null;
    notifyListeners();

    if (!_validator.isValidPlayerId(_playerId)) {
      _isLoading = false;
      _playerIdError = '아이디 형식이 맞지 않습니다.';
      notifyListeners();
      return;
    }

    if (!_validator.isValidPassword(_password)) {
      _isLoading = false;
      _passwordError = '비밀번호 형식이 맞지 않습니다.';
      notifyListeners();
      return;
    }

    try {
      final response = await _authRepository.login(_playerId, _password);

      _isLoading = false;
      notifyListeners();

      if (response['result'] == true) {
        final authModel = AuthModel(playerId: _playerId, password: _password);
        context.read<AuthModel>().update(authModel); // AuthModel 업데이트

        context.go('/'); // 홈 화면으로 이동
      } else {
        _playerIdError = response['msg'] ?? '로그인 실패';
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _errorPopUtil.showErrorDialog(context, '오류', '오류가 발생했습니다.');
      notifyListeners();
    }
  }
}
