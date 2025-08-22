import 'package:flutter/material.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_report_provider.dart';

class DiscardChangesDialogWidget extends StatelessWidget {
  const DiscardChangesDialogWidget({super.key});

  Future<bool> showOnScreen(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => this,
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Discard Changes?'),
      content: const Text('Are you sure you want to discard your changes?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => GameScoutingReportProvider.goToHomeScreen(context),
          child: const Text('Discard'),
        ),
      ],
    );
  }
}
