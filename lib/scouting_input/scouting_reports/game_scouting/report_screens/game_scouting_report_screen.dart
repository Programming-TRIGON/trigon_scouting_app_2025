import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_page.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_report_provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/discard_changes_dialog_widget.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/report_screens/endgame_report_screen.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/report_screens/postgame_questions_report_screen.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/report_screens/postgame_review_report_screen.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/report_screens/pregame_report_screen.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/report_screens/teleop_report_screen.dart";
import "package:trigon_scouting_app_2025/scouting_input/providers/scouted_competition/scouted_competition_provider.dart";

import "package:trigon_scouting_app_2025/utilities/material_design_factory.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/report_screens/auto_report_screen.dart";

class GameScoutingReportScreen extends StatelessWidget {
  const GameScoutingReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await onPopInvoked(context);
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: buildCurrentScoutingReportPage(context),
    );
  }

  Widget buildCurrentScoutingReportPage(BuildContext context) {
    final reportProvider = context.watch<GameScoutingReportProvider>();
    final scoutedCompetitionProvider = context.watch<ScoutedCompetitionProvider>();

    if (scoutedCompetitionProvider.scoutedCompetition == null) {
      return MaterialDesignFactory.createLoadingPage("Scouted Competition Loading...");
    }

    switch (reportProvider.page) {
      case GameScoutingPage.pregame:
        return const PregameReportScreen();
      case GameScoutingPage.auto:
        return const AutoReportScreen();
      case GameScoutingPage.teleop:
        return const TeleopReportScreen();
      case GameScoutingPage.endgame:
        return const EndgameReportScreen();
      case GameScoutingPage.review:
        return const PostgameReviewReportScreen();
      case GameScoutingPage.questions:
        return const PostgameQuestionsReportScreen();
      default:
        return const PregameReportScreen();
    }
  }

  Future<bool> onPopInvoked(BuildContext context) async {
    return await const DiscardChangesDialogWidget().showOnScreen(context);
  }
}
