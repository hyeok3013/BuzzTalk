import 'package:alarm_app/src/repository/auth_repository.dart';
import 'package:alarm_app/src/repository/http_request.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alarm_app/src/view/auth/login_view_model.dart';
import 'package:alarm_app/src/view/auth/rgt_view.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final httpRequest = Http();
    final authRepository = AuthRepository(httpRequest);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider(
        create: (_) => LoginViewModel(authRepository),
        child: Padding(
          padding: const EdgeInsets.only(right: 24.0, left: 12),
          child: Consumer<LoginViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        // BuzzTalk 텍스트 배치
                        const Positioned(
                          left: 28, // 왼쪽 정렬 위치를 TextField와 맞춤
                          top: 150, // 아래로 더 내림
                          child: Text(
                            'BuzzTalk',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 28, // TextField와 동일한 left 위치
                          top: 500,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 317,
                                height: 60, // TextField와 동일한 width
                                child: ElevatedButton(
                                  onPressed: viewModel.isLoading
                                      ? null
                                      : () {
                                          viewModel
                                              .signIn(context); // context 전달
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 20, 42, 128),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: viewModel.isLoading
                                      ? const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        )
                                      : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '로그인',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Airbnb Cereal App',
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Icon(Icons.arrow_forward,
                                                color: Colors.white),
                                          ],
                                        ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignUp()),
                                  );
                                },
                                child: const DonTHaveAnAccountSignUp(),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 28,
                          top: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 317,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xFFE4DEDE)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.person,
                                          color: Color(0xFF747688)),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: TextField(
                                          onChanged: (value) =>
                                              viewModel.updatePlayerId(value),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '아이디',
                                            hintStyle: TextStyle(
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
                              if (viewModel.playerIdError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    viewModel.playerIdError!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 28,
                          top: 344,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 317,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xFFE4DEDE)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.lock,
                                          color: Color(0xFF747688)),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: TextField(
                                          obscureText: viewModel.isObscureText,
                                          onChanged: (value) =>
                                              viewModel.updatePassword(value),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '비밀번호',
                                            hintStyle: TextStyle(
                                              color: Color(0xFF747688),
                                              fontSize: 14,
                                              fontFamily: 'Airbnb Cereal App',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            viewModel.toggleObscureText(),
                                        child: Icon(
                                          viewModel.isObscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: const Color(0xFF747688),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class DonTHaveAnAccountSignUp extends StatelessWidget {
  const DonTHaveAnAccountSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '계정',
            style: TextStyle(
              color: Color(0xFF110C26),
              fontSize: 15,
              fontFamily: 'Airbnb Cereal App',
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          TextSpan(
            text: '이 없으신가요?  ',
            style: TextStyle(
              color: Color(0xFF110C26),
              fontSize: 15,
              fontFamily: 'Airbnb Cereal App',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          TextSpan(
            text: '회원가입',
            style: TextStyle(
              color: Color.fromARGB(255, 20, 42, 128),
              fontSize: 15,
              fontFamily: 'Airbnb Cereal App',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
