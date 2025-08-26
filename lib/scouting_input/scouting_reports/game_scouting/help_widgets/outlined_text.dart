import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color strokeColor;
  final double strokeWidth;

  const OutlinedText({
    super.key,
    required this.text,
    this.style,
    required this.strokeColor,
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Outline
        Text(
          text,
          style: (style ?? const TextStyle()).copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        // Fill
        Text(
          text,
          style: style,
        ),
      ],
    );
  }
}
