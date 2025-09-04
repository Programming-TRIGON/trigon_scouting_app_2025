import 'package:flutter/material.dart';

class Mandatory extends StatelessWidget {
  final Widget child;
  final bool show;

  const Mandatory({
    super.key,
    required this.child,
    this.show = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (show)
          const Positioned(
            top: -11,   // move slightly above the border
            left: 5, // move slightly outside the border
            child: Text(
              '*',
              style: TextStyle(
                color: Colors.red,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
