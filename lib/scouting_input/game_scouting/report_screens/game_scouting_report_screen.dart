import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_page.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_report_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/help_widgets/discard_changes_dialog_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/report_screens/endgame_report_screen.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/report_screens/postgame_report_screen.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/report_screens/pregame_report_screen.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/report_screens/teleop_report_screen.dart';

import 'auto_report_screen.dart';

class GameScoutingReportScreen extends StatelessWidget {
  const GameScoutingReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await onPopInvoked(context);
        if (shouldPop) {
          Navigator.of(context).pop();
        }
      },
      child: buildCurrentScoutingReportPage(context),
    );
  }

  Widget buildCurrentScoutingReportPage(BuildContext context) {
    final reportProvider = context.watch<GameScoutingReportProvider>();

    switch (reportProvider.page) {
      case GameScoutingPage.pregame:
        return PregameReportScreen();
      case GameScoutingPage.auto:
        return AutoReportScreen();
      case GameScoutingPage.teleop:
        return TeleopReportScreen();
      case GameScoutingPage.endgame:
        return EndgameReportScreen();
      case GameScoutingPage.postgame:
        return PostgameReportScreen();
      default:
        return PregameReportScreen();
    }
  }

  Future<bool> onPopInvoked(BuildContext context) async {
    return await DiscardChangesDialogWidget().showOnScreen(context);
  }
}
