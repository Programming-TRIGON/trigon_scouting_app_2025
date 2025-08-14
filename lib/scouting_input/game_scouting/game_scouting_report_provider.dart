import 'package:flutter/material.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_page.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_report.dart';

import 'help_widgets/discard_changes_dialog_widget.dart';

class GameScoutingReportProvider extends ChangeNotifier {
  late GameScoutingReport _report;
  GameScoutingPage _page = GameScoutingPage.pregame;

  GameScoutingReport get report => _report;
  GameScoutingPage get page => _page;

  GameScoutingReportProvider(String scouterUID) {
    _report = GameScoutingReport.withUID(scouterUID);
    notifyListeners();
  }

  void moveToPage(BuildContext context, GameScoutingPage targetPage, Function(BuildContext, String) notAbleToMoveToPageCallback) async {
    if (targetPage == GameScoutingPage.discard) {
      final shouldPop = await DiscardChangesDialogWidget().showOnScreen(
        context,
      );
      if (shouldPop && context.mounted) {
        Navigator.pop(context);
      }
      return;
    }

    if (targetPage == GameScoutingPage.submit) {
      await submit();
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scouting form submitted successfully!'),
              backgroundColor: Colors.green),
        );
      }
      return;
    }

    String? canMoveToPage = targetPage.canMoveToPage(this);

    if (canMoveToPage == null) {
      _page = targetPage;
    } else {
      notAbleToMoveToPageCallback(context, canMoveToPage);
    }
    notifyListeners();
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

  String? validate() {
    return _report.pregameReport.validate() ??
           _report.autoReport.validate() ??
           _report.teleopReport.validate() ??
           _report.endgameReport.validate();
  }

  Future<void> submit() async {
    final error = validate();
    if (error != null) {
      throw Exception(error);
    }
    await _report.sendToFirebase();
  }
}
