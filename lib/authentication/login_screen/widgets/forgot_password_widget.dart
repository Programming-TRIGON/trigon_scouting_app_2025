import 'package:flutter/material.dart';
import 'package:trigon_scouting_app_2025/utilities/firebase_handler.dart';

class ForgotPasswordWidget extends StatelessWidget {
  const ForgotPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showResetPasswordDialog(context),
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.hovered)) {
            return Colors.blue;
          }
          return Theme.of(context).disabledColor;
        }),
        textStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          if (states.contains(WidgetState.hovered)) {
            return const TextStyle(decoration: TextDecoration.underline);
          }
          return const TextStyle(decoration: TextDecoration.none);
        }),
      ),
      child: const Text('Forgot password?'),
    );
  }

  void showResetPasswordDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter you email to reset password'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'E-mail'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final String email = controller.text;
              if (email.isNotEmpty) {
                await FirebaseHandler.resetPassword(context: context, email: email);
              }
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
