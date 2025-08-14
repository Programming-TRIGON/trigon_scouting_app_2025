import 'package:flutter/material.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_home_screen.dart';
import 'package:trigon_scouting_app_2025/utilities/material_design_factory.dart';

class DiscardChangesDialogWidget extends StatelessWidget {
  const DiscardChangesDialogWidget({super.key});

  Future<bool> showOnScreen(BuildContext context) async {
    return await showDialog<bool>(
        context: context,
        builder: (context) => this
    ) ?? false;
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
          onPressed: () => Navigator.of(context).pushReplacement(MaterialDesignFactory.createModernRoute(ScoutingHomeScreen())),
          child: const Text('Discard'),
        ),
      ],
    );
  }
}
