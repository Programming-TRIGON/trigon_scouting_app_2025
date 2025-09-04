import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/authentication/login_screen/login_provider.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<LoginProvider>();

    return SizedBox(
      width: 400,
      height: 50,
      child: ElevatedButton(
        onPressed: () => provider.signIn(context),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.green,
        ),
        child: const Text('Sign in', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
