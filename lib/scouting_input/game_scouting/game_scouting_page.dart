import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_report_provider.dart';

enum GameScoutingPage {
  discard,
  pregame,
  auto,
  teleop,
  endgame,
  questions,
  review,
  submit;

  String capitalizedName() {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  GameScoutingPage getPrevious() {
    return GameScoutingPage.values[index - 1];
  }

  GameScoutingPage getNext() {
    return GameScoutingPage.values[index + 1];
  }

  String? canMoveToPage(GameScoutingReportProvider reportProvider) {
    if (reportProvider.page.index >= index) return null;
    switch (this) {
      case GameScoutingPage.pregame:
        return null;
      case GameScoutingPage.auto:
        return reportProvider.report.pregameReport.validate();
      case GameScoutingPage.teleop:
        return reportProvider.report.autoReport.validate();
      case GameScoutingPage.endgame:
        return reportProvider.report.teleopReport.validate();
      case GameScoutingPage.questions:
        return reportProvider.report.endgameReport.validate();
      case GameScoutingPage.review:
        return reportProvider.report.postgameReport.validate();
      case GameScoutingPage.submit:
        return reportProvider.validate();
      default: return null;
    }
  }
}