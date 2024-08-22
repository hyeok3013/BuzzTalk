import 'package:flutter/material.dart';
import 'package:alarm_app/src/repository/auth_repository.dart';
import 'package:alarm_app/src/view/auth/login_view.dart';
import 'package:alarm_app/util/auth_utils.dart';
import 'package:alarm_app/util/error_pop_util.dart';

class RgtViewModel extends ChangeNotifier {
  String _playerId = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isLoading = false;
  bool _obscureText = true;
  bool _obscureConfirmText = true;

  String? _playerIdError;
  String? _passwordError;

  final AuthRepository _authRepository;
  final AuthUtils _validator = AuthUtils();
  final ErrorPopUtils _errorPopUtil = ErrorPopUtils();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  RgtViewModel(this._authRepository);

  String get playerId => _playerId;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get isLoading => _isLoading;
  bool get obscureText => _obscureText;
  bool get obscureConfirmText => _obscureConfirmText;

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

  void updateConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    notifyListeners();
  }

  void toggleObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  void toggleObscureConfirmText() {
    _obscureConfirmText = !_obscureConfirmText;
    notifyListeners();
  }

  bool passwordsMatch() {
    return _password == _confirmPassword;
  }

  Future<void> signUp(BuildContext context) async {
    _setLoadingState(true);

    if (!_validateInputs(context)) {
      _setLoadingState(false);
      return;
    }

    try {
      final response = await _authRepository.register(_playerId, _password);
      _handleResponse(context, response);
    } catch (e) {
      _errorPopUtil.showErrorDialog(context, '회원가입 실패', '잠시 후 다시 시도해주세요.');
    } finally {
      _setLoadingState(false);
    }
  }

  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  bool _validateInputs(BuildContext context) {
    if (!_validator.isValidPlayerId(_playerId)) {
      _playerIdError = '아이디 형식이 맞지 않습니다.';
      _clearPasswordFields();
      return false;
    }

    if (!_validator.isValidPassword(_password)) {
      _passwordError = '비밀번호 형식이 맞지 않습니다.';
      _clearPasswordFields();
      return false;
    }

    if (!passwordsMatch()) {
      _errorPopUtil.showErrorDialog(context, '비밀번호 불일치', '다시 시도하세요');
      _clearPasswordFields();
      return false;
    }

    return true;
  }

  void _handleResponse(BuildContext context, Map<String, dynamic> response) {
    if (response['result'] == true) {
      _navigateToLogin(context);
    } else {
      _errorPopUtil.showErrorDialog(context, '회원가입 실패', response['msg']);
    }
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  void _clearPasswordFields() {
    passwordController.clear();
    confirmPasswordController.clear();
    _password = '';
    _confirmPassword = '';
    _obscureText = true;
    _obscureConfirmText = true;
    notifyListeners();
  }
}
