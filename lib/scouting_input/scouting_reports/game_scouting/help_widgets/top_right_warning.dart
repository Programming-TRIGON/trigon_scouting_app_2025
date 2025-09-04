import "package:flutter/material.dart";

class TopRightWarning extends StatefulWidget {
  final String message;
  final Duration duration;
  final bool isError;

  const TopRightWarning({
    super.key,
    required this.message,
    this.duration = const Duration(seconds: 2),
    this.isError = true,
  });

  static void showOnScreen(
    BuildContext context,
    String message, {
    bool isError = true,
    Duration duration = const Duration(seconds: 2),
  }) {
    final key = GlobalKey<_TopRightWarningState>();
    final overlay = OverlayEntry(
      builder: (context) => TopRightWarning(
        key: key,
        message: message,
        isError: isError,
        duration: duration,
      ),
    );
    Overlay.of(context).insert(overlay);

    // Schedule hiding after duration
    Future.delayed(duration, () {
      key.currentState?.hideOverlay(overlay);
    });
  }

  @override
  State<TopRightWarning> createState() => _TopRightWarningState();
}

class _TopRightWarningState extends State<TopRightWarning>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
  }

  void hideOverlay(OverlayEntry overlay) {
    if (controller.isAnimating) return;
    controller.forward().then((_) {
      overlay.remove();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isError
        ? Colors.red.shade400
        : Colors.green.shade400;
    const iconColor = Colors.white;
    final icon = widget.isError
        ? Icons.warning_amber
        : Icons.check_circle_outline;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 10.0,
      right: 10.0,
      child: FadeTransition(
        opacity: animation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
