import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alarm_app/src/view/auth/chg_pwd_view_model.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordCheckController =
      TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordCheckController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("비밀번호 변경"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "기존 비밀번호",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // 모서리 둥글기 설정
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.grey, // 기본 상태의 테두리 색상
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 20, 42, 128), // 포커스된 상태의 테두리 색상
                    width: 2.0, // 테두리 두께
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "새로운 비밀번호",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // 모서리 둥글기 설정
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.grey, // 기본 상태의 테두리 색상
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 20, 42, 128), // 포커스된 상태의 테두리 색상
                    width: 2.0, // 테두리 두께
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordCheckController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "비밀번호 확인",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // 모서리 둥글기 설정
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.grey, // 기본 상태의 테두리 색상
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 20, 42, 128), // 포커스된 상태의 테두리 색상
                    width: 2.0, // 테두리 두께
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                try {
                  await context.read<ChangePasswordViewModel>().changePassword(
                        oldPassword: _oldPasswordController.text,
                        newPassword: _newPasswordController.text,
                        newPasswordCheck: _newPasswordCheckController.text,
                        context: context, // 여기에 context를 추가
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("비밀번호가 성공적으로 변경되었습니다."),
                    ),
                  );
                  Navigator.pop(context); // 작업 후 이전 화면으로 돌아감
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("비밀번호 변경에 실패했습니다: $e")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 20, 42, 128),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    "비밀번호 변경",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
