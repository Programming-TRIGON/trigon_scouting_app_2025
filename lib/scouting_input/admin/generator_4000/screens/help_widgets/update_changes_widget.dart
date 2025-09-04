import "package:flutter/material.dart";

class UpdateChangesWidget extends StatelessWidget {
  final String keyString;
  final void Function()? onUpdate;
  final void Function()? onDiscard;
  final bool isUpdateAvailable;

  UpdateChangesWidget({
    required this.keyString,
    this.onUpdate,
    this.onDiscard,
    this.isUpdateAvailable = false,
  }) : super(key: ValueKey(keyString));

  @override
  Widget build(BuildContext context) {
    final activeSaveColor = Colors.green.shade700;
    final activeDiscardColor = Colors.red.shade700;
    final disabledOverlay = Theme.of(context).disabledColor.withValues(alpha: 0.4);

    return Row(
      children: [
        FloatingActionButton(
          key: ValueKey("update_changes_$keyString"),
          heroTag: "update_changes_$keyString",
          onPressed: isUpdateAvailable ? (() => onUpdate?.call()) : null,
          shape: const CircleBorder(),
          backgroundColor: isUpdateAvailable
              ? activeSaveColor
              : activeSaveColor.withValues(alpha: 0.4), // greyed out look
          foregroundColor:
          isUpdateAvailable ? Colors.white : disabledOverlay, // icon tint
          tooltip: "חלל אותי",
          child: const Icon(Icons.save),
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          key: ValueKey("discard_changes_$keyString"),
          heroTag: "discard_changes_$keyString",
          onPressed: isUpdateAvailable ? (() => onDiscard?.call()) : null,
          shape: const CircleBorder(),
          backgroundColor: isUpdateAvailable
              ? activeDiscardColor
              : activeDiscardColor.withValues(alpha: 0.4),
          foregroundColor:
          isUpdateAvailable ? Colors.white : disabledOverlay,
          tooltip: "Discard Changes",
          child: const Icon(Icons.folder_delete),
        ),
      ],
    );
  }
}
