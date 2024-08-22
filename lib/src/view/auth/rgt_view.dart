import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alarm_app/src/view/auth/rgt_view_model.dart';
import 'package:alarm_app/src/repository/auth_repository.dart';
import 'package:alarm_app/src/repository/http_request.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final httpRequest = Http();
    final authRepository = AuthRepository(httpRequest);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ChangeNotifierProvider(
        create: (_) => RgtViewModel(authRepository),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Consumer<RgtViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        color: Color(0xFF110C26),
                        fontSize: 24,
                        fontFamily: 'Airbnb Cereal App',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildLabel('아이디'),
                        _buildInputField(
                          icon: Icons.person,
                          hintText: '아이디',
                          onChanged: viewModel.updatePlayerId,
                        ),
                        const SizedBox(height: 30),
                        _buildLabel('비밀번호'),
                        _buildPasswordField(
                          controller: viewModel.passwordController,
                          icon: Icons.lock,
                          hintText: '비밀번호',
                          obscureText: viewModel.obscureText,
                          onChanged: viewModel.updatePassword,
                          onToggle: viewModel.toggleObscureText,
                        ),
                        if (viewModel.passwordError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              viewModel.passwordError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        _buildPasswordField(
                          controller: viewModel.confirmPasswordController,
                          icon: Icons.lock,
                          hintText: '비밀번호 확인',
                          obscureText: viewModel.obscureConfirmText,
                          onChanged: viewModel.updateConfirmPassword,
                          onToggle: viewModel.toggleObscureConfirmText,
                        ),
                        const SizedBox(height: 60),
                        _buildButton(
                          text: '회원가입 완료',
                          color: const Color.fromARGB(255, 20, 42, 128),
                          textColor: Colors.white,
                          icon: Icons.arrow_forward,
                          onPressed: viewModel.isLoading
                              ? null
                              : () {
                                  viewModel.signUp(context);
                                },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '이미 ',
                                        style: TextStyle(
                                          color: Color(0xFF110C26),
                                          fontSize: 15,
                                          fontFamily: 'Airbnb Cereal App',
                                          fontWeight: FontWeight.w400,
                                          height: 1.5,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '계정',
                                        style: TextStyle(
                                          color: Color(0xFF110C26),
                                          fontSize: 15,
                                          fontFamily: 'Airbnb Cereal App',
                                          fontWeight:
                                              FontWeight.bold, // Bold 체 적용
                                          height: 1.5,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '이 있으신가요?    ',
                                        style: TextStyle(
                                          color: Color(0xFF110C26),
                                          fontSize: 15,
                                          fontFamily: 'Airbnb Cereal App',
                                          fontWeight: FontWeight.w400,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextSpan(
                                    text: '로그인 하기',
                                    style: TextStyle(
                                      color: Color(0xFF5668FF),
                                      fontSize: 15,
                                      fontFamily: 'Airbnb Cereal App',
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (viewModel.isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 23.0),
      child: Text(
        labelText,
        style: const TextStyle(
          color: Color(0xFF110C26),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String hintText,
    required Function(String) onChanged,
  }) {
    return Center(
      child: Container(
        width: 317,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE4DEDE)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF747688)),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: Color(0xFF747688),
                      fontSize: 14,
                      fontFamily: 'Airbnb Cereal App',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    required bool obscureText,
    required Function(String) onChanged,
    required VoidCallback onToggle,
  }) {
    return Center(
      child: Container(
        width: 317,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE4DEDE)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF747688)),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: Color(0xFF747688),
                      fontSize: 14,
                      fontFamily: 'Airbnb Cereal App',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onToggle,
                child: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF747688),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required Color textColor,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          fixedSize: const Size(315, 56),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontFamily: 'Airbnb Cereal App',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 10),
            Icon(icon, color: textColor),
          ],
        ),
      ),
    );
  }
}
