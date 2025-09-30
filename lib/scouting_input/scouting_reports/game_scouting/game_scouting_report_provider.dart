import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:trigon_scouting_app_2025/authentication/authentication_handler.dart";
import "package:trigon_scouting_app_2025/authentication/user_data_provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_page.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_report.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/top_right_warning.dart";
import "package:trigon_scouting_app_2025/scouting_input/home_screen/scouting_home_screen.dart";
import "package:trigon_scouting_app_2025/scouting_input/providers/scouted_competition/scouted_competition_provider.dart";
import "package:trigon_scouting_app_2025/utilities/firebase_handler.dart";

import "package:trigon_scouting_app_2025/utilities/material_design_factory.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/discard_changes_dialog_widget.dart";

class GameScoutingReportProvider extends ChangeNotifier {
  late GameScoutingReport _report;
  GameScoutingPage _page = GameScoutingPage.pregame;

  GameScoutingReport get report => _report;

  GameScoutingPage get page => _page;

  GameScoutingReportProvider(String scouterUID) {
    _report = GameScoutingReport.withUID(scouterUID);
    notifyListeners();
  }

  void moveToPage(
    BuildContext context,
    GameScoutingPage targetPage
  ) async {
    if (targetPage == GameScoutingPage.discard) {
      await const DiscardChangesDialogWidget().showOnScreen(context);
      return;
    }

    if (targetPage == GameScoutingPage.submit) {
      await submit(context);
      return;
    }

    final String? canMoveToPage = targetPage.canMoveToPage(this);

    if (canMoveToPage == null) {
      _page = targetPage;
    } else {
      TopRightWarning.showOnScreen(context, canMoveToPage);
    }
    notifyListeners();
  }

  static void goToHomeScreen(BuildContext context) async {
    final userDataProvider = context.read<UserDataProvider>();
    if (userDataProvider.role!.hasViewerAccess) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialDesignFactory.createNoAnimationRoute(const AuthenticationHandler()),
        (route) => false,
      );
      Navigator.of(
        context,
      ).push(MaterialDesignFactory.createModernRoute(const ScoutingHomeScreen()));
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialDesignFactory.createModernRoute(const AuthenticationHandler()),
        (route) => false,
      );
    }
  }

  void updateReport(void Function(GameScoutingReport) updater) {
    updater(_report);
    notifyListeners();
  }

  void notifyUpdate() {
    notifyListeners();
  }

  void updatePregame(void Function(PregameScoutingReport) updater) {
    updater(_report.pregameReport);
    notifyListeners();
  }

  void updateAuto(void Function(AutoScoutingReport) updater) {
    updater(_report.autoReport);
    notifyListeners();
  }

  void updateTeleop(void Function(TeleopScoutingReport) updater) {
    updater(_report.teleopReport);
    notifyListeners();
  }

  void updateEndgame(void Function(EndgameScoutingReport) updater) {
    updater(_report.endgameReport);
    notifyListeners();
  }

  void updatePostgame(void Function(PostgameReport) updater) {
    updater(_report.postgameReport);
    notifyListeners();
  }

  String? validate() {
    if (_report.pregameReport.showedUp == false && _report.pregameReport.validate() == null) {
      return null;
    }

    return _report.pregameReport.validate() ??
        _report.autoReport.validate() ??
        _report.teleopReport.validate() ??
        _report.endgameReport.validate() ??
        _report.postgameReport.validate();
  }

  Future<void> submit(BuildContext context) async {
    final error = validate();
    if (error != null) {
      TopRightWarning.showOnScreen(context, error);
      return;
    }

    final scoutedCompetitionProvider = context.read<ScoutedCompetitionProvider>();
    FirebaseHandler.uploadGameScoutingReport(report, scoutedCompetitionProvider.scoutedCompetition?.competitionKey);
    scoutedCompetitionProvider.markGameScoutingShiftScouted(_report.scouterUID, _report.pregameReport.getMatchKey());
    if (report.pregameReport.showedUp == true) {
      scoutedCompetitionProvider.updateBoundingScores(report.calculateTotalPoint());
    }

    if (context.mounted) {
      goToHomeScreen(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Scouting form submitted successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
