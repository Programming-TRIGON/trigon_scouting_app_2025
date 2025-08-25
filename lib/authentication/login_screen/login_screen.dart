import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/authentication/login_screen/login_provider.dart';
import 'package:trigon_scouting_app_2025/authentication/login_screen/widgets/forgot_password_widget.dart';
import 'package:trigon_scouting_app_2025/authentication/login_screen/widgets/login_form_widget.dart';
import 'package:trigon_scouting_app_2025/authentication/login_screen/widgets/login_header_widget.dart';
import 'package:trigon_scouting_app_2025/authentication/login_screen/widgets/sign_in_widget.dart';
import 'package:trigon_scouting_app_2025/utilities/material_design_factory.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MaterialDesignFactory.createAppBar(
          context,
          Colors.blue,
          null,
          null,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 56, left: 24, bottom: 24, right: 24),
            child: Center(
              child: Column(
                children: [
                  LoginHeaderWidget(),
                  SizedBox(height: 16),
                  LoginFormWidget(),
                  SizedBox(height: 8),
                  ForgotPasswordWidget(),
                  SizedBox(height: 8),
                  SignInWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
