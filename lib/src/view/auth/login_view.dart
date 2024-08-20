import 'package:alarm_app/src/repository/auth_repository.dart';
import 'package:alarm_app/src/repository/http_request.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alarm_app/src/view/auth/login_view_model.dart';
import 'package:alarm_app/src/view/auth/rgt_view.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final httpRequest = Http();
    final authRepository = AuthRepository(httpRequest);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider(
        create: (_) => LoginViewModel(authRepository),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Consumer<LoginViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          left: 50,
                          top: 500,
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: viewModel.isLoading
                                    ? null
                                    : () {
                                        viewModel.signIn(context); // context 전달
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF3D55F0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  minimumSize: Size(273, 56),
                                ),
                                child: viewModel.isLoading
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'SIGN IN',
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
                              SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()),
                                  );
                                },
                                child: DonTHaveAnAccountSignUp(),
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
                                  border: Border.all(color: Color(0xFFE4DEDE)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    children: [
                                      Icon(Icons.person,
                                          color: Color(0xFF747688)),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: TextField(
                                          onChanged: (value) =>
                                              viewModel.updatePlayerId(value),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'ID',
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
                                    style: TextStyle(
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
                                  border: Border.all(color: Color(0xFFE4DEDE)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    children: [
                                      Icon(Icons.lock,
                                          color: Color(0xFF747688)),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: TextField(
                                          obscureText: viewModel.isObscureText,
                                          onChanged: (value) =>
                                              viewModel.updatePassword(value),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'PW',
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
                                          color: Color(0xFF747688),
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
                                    style: TextStyle(
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
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Don’t have an account?  ',
            style: TextStyle(
              color: Color(0xFF110C26),
              fontSize: 15,
              fontFamily: 'Airbnb Cereal App',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          TextSpan(
            text: 'Sign up',
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
    );
  }
}
