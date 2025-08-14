import 'package:flutter/material.dart';

class ForgotPasswordWidget extends StatelessWidget {
  const ForgotPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
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
      child: const Text("Forgot password?"),
    );
  }
}
