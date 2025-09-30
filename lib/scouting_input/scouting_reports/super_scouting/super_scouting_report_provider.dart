import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:trigon_scouting_app_2025/authentication/authentication_handler.dart";
import "package:trigon_scouting_app_2025/authentication/user_data_provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/home_screen/scouting_home_screen.dart";
import "package:trigon_scouting_app_2025/scouting_input/providers/scouted_competition/scouted_competition_provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/discard_changes_dialog_widget.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/top_right_warning.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/super_scouting/super_scouting_report.dart";
import "package:trigon_scouting_app_2025/utilities/firebase_handler.dart";
import "package:trigon_scouting_app_2025/utilities/material_design_factory.dart";
import "package:trigon_scouting_app_2025/utilities/tba_handler.dart";

class SuperScoutingReportProvider extends ChangeNotifier {
  late SuperScoutingReport report;
  int currentPageIndex = 0;
  bool? isBlueAlliance;
  bool didOverrideSelection = false;

  SuperScoutingReportProvider(String scouterUID) {
    report = SuperScoutingReport(scouterUID: scouterUID);
    notifyListeners();
  }

  void changePage(int newIndex) {
    currentPageIndex = newIndex;
    notifyListeners();
  }

  void updateAlliance(bool? isBlue, ScoutedCompetitionProvider scoutedCompetitionProvider) {
    isBlueAlliance = isBlue;
    final List<FRCTeam>? teams = scoutedCompetitionProvider.getTeamsInMatchAlliance(report.matchKeyReport.getMatchKey(), isBlueAlliance);
    if (teams != null) {
      report.updateTeams(teams);
    } else {
      report.updateTeams([null, null, null]);
    }
    notifyListeners();
  }

  void updateOverrideSelection(bool didOverride) {
    didOverrideSelection = didOverride;
    notifyListeners();
  }

  void updateReport(void Function(SuperScoutingReport) updater) {
    updater(report);
    notifyListeners();
  }

  void submit(BuildContext context) async {
    final error = report.validate();
    if (error != null) {
      TopRightWarning.showOnScreen(context, error);
      return;
    }

    final scoutedCompetitionProvider = context
        .read<ScoutedCompetitionProvider>();
    FirebaseHandler.uploadSuperScoutingReport(
      report,
      scoutedCompetitionProvider.scoutedCompetition?.competitionKey,
    );
    scoutedCompetitionProvider.markSuperScoutingShiftScouted(
      report.scouterUID,
      report.matchKeyReport.getMatchKey(),
    );

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

  Future<void> discardChanges(BuildContext context) async {
    await const DiscardChangesDialogWidget().showOnScreen(context);
    notifyListeners();
  }

  static void goToHomeScreen(BuildContext context) async {
    final userDataProvider = context.read<UserDataProvider>();
    if (userDataProvider.role!.hasViewerAccess) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialDesignFactory.createNoAnimationRoute(
          const AuthenticationHandler(),
        ),
        (route) => false,
      );
      Navigator.of(context).push(
        MaterialDesignFactory.createModernRoute(const ScoutingHomeScreen()),
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialDesignFactory.createModernRoute(const AuthenticationHandler()),
        (route) => false,
      );
    }
  }
}
