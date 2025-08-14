import 'package:flutter/material.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Welcome back,", style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text("sign in to continue", style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
