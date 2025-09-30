import "package:trigon_scouting_app_2025/utilities/tba_handler.dart";

class SuperScoutingReport {
  final String scouterUID;

  final MatchKeyReport matchKeyReport = MatchKeyReport();
  final List<RobotSuperScoutingReport> robotReports = List.generate(
    3,
    (index) => RobotSuperScoutingReport(),
  );

  SuperScoutingReport({required this.scouterUID});

  void updateTeams(List<FRCTeam?> teams) {
    for (int i = 0; i < 3; i++) {
      robotReports[i].robotNumber = teams[i]?.teamID;
    }
  }

  String? validate() {
    final String? allianceTypeError = matchKeyReport.validate();
    if (allianceTypeError != null) return allianceTypeError;

    for (var report in robotReports) {
      final String? robotError = report.validate();
      if (robotError != null) return robotError;
    }

    return null;
  }
}

class MatchKeyReport {
  String? matchType;
  int? matchNumber;

  String? validate() {
    if (matchType == null) return "Please select match type";
    if (matchNumber == null) return "Please select match number";
    return null;
  }

  String? getMatchKey() {
    return FRCMatch.toMatchKey(matchType, matchNumber?.toString());
  }
}

class RobotSuperScoutingReport {
  int? robotNumber;
  String? notes;
  bool didDefend = false;
  int defenceRate = 1;

  Map<String, dynamic> toMap() {
    return {
      "SuperScouting": {
        "notes": notes,
        "didDefend": didDefend,
        "defenceRate": defenceRate,
      },
    };
  }

  String? validate() {
    if (robotNumber == null) return "Please select robot number";
    return null;
  }
}
