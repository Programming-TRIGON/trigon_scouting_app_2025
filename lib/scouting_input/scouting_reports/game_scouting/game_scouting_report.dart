import "package:trigon_scouting_app_2025/utilities/tba_handler.dart";

class GameScoutingReport {
  final String scouterUID;

  final PregameScoutingReport pregameReport;
  final AutoScoutingReport autoReport;
  final TeleopScoutingReport teleopReport;
  final EndgameScoutingReport endgameReport;
  final PostgameReport postgameReport;

  const GameScoutingReport({
    required this.scouterUID,
    required this.pregameReport,
    required this.autoReport,
    required this.teleopReport,
    required this.endgameReport,
    required this.postgameReport,
  });

  GameScoutingReport.withUID(this.scouterUID)
      : pregameReport = PregameScoutingReport(),
        autoReport = AutoScoutingReport(),
        teleopReport = TeleopScoutingReport(),
        endgameReport = EndgameScoutingReport(),
        postgameReport = PostgameReport();

  GameScoutingReport copyWith({
    PregameScoutingReport? pregameReport,
    AutoScoutingReport? autoReport,
    TeleopScoutingReport? teleopReport,
    EndgameScoutingReport? endgameReport,
    PostgameReport? postgameReport,
  }) {
    return GameScoutingReport(
      scouterUID: scouterUID,
      pregameReport: pregameReport ?? this.pregameReport,
      autoReport: autoReport ?? this.autoReport,
      teleopReport: teleopReport ?? this.teleopReport,
      endgameReport: endgameReport ?? this.endgameReport,
      postgameReport: postgameReport ?? this.postgameReport,
    );
  }

  int calculateTotalPoints() {
    return autoReport.calculateTotalPoints() +
        teleopReport.calculateTotalPoints() +
        endgameReport.calculateTotalPoints();
  }

  int calculateCycles() {
    return autoReport.calculateCycles() +
        teleopReport.calculateCycles();
  }

  void processReport() {
    if (pregameReport.showedUp == false) {
      pregameReport.startingPosition = null;
      pregameReport.bet = null;
      autoReport.reset();
      teleopReport.reset();
      endgameReport.reset();
      postgameReport.reset();
      return;
    }

    if (autoReport.crossedAutoLine != true) {
      autoReport.reset();
    }

    if (endgameReport.didTryToClimb != true) {
      endgameReport.deepCage = null;
      endgameReport.didManageToClimb = null;
      endgameReport.climbFailureReason = null;
    } else {
      if (endgameReport.didManageToClimb == true) {
        endgameReport.climbFailureReason = null;
      } else {
        endgameReport.didPark = true;
      }
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "GameScouting": {
        "Pregame": pregameReport.toMap(),
        "Auto": autoReport.toMap(),
        "Teleop": teleopReport.toMap(),
        "Endgame": endgameReport.toMap(),
        "Postgame": postgameReport.toMap(),
      },
    };
  }
}

class Placements {
  int successes = 0;
  int misses = 0;

  void addSuccess() {
    successes++;
  }

  void removeSuccess() {
    if (successes == 0) return;
    successes--;
  }

  void addMiss() {
    misses++;
  }

  void removeMiss() {
    if (misses == 0) return;
    misses--;
  }

  Map<String, int> toMap() {
    return {"successes": successes, "misses": misses};
  }
}

class PregameScoutingReport {
  String? matchType;
  int? matchNumber;
  bool didOverrideSelection = false;
  int? robotNumber;
  bool? showedUp;
  int? startingPosition;
  bool? bet;

  String? getMatchKey() {
    return FRCMatch.toMatchKey(matchType, matchNumber?.toString());
  }

  String? validate() {
    if (matchType == null) return "Please select match type";
    if (matchNumber == null) return "Please select match number";
    if (robotNumber == null) return "Please select robot number";
    if (showedUp == null) return "Please select whether the team showed up";
    if (showedUp == true && startingPosition == null) {
      return "Please select a starting position";
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      "showedUp": showedUp,
      "startingPosition": startingPosition,
      "didOverrideSelection": didOverrideSelection
    };
  }
}

class AutoScoutingReport {
  bool? crossedAutoLine;
  final Placements l4CoralPlacements = Placements();
  final Placements l3CoralPlacements = Placements();
  final Placements l2CoralPlacements = Placements();
  final Placements l1CoralPlacements = Placements();

  late List<Placements> coralPlacements = [
    l1CoralPlacements,
    l2CoralPlacements,
    l3CoralPlacements,
    l4CoralPlacements,
  ];

  final Placements netAlgaePlacements = Placements();
  int processorAlgaeCount = 0;
  int algaeOutOfReefCount = 0;

  void reset() {
    crossedAutoLine = null;
    l4CoralPlacements.successes = 0;
    l4CoralPlacements.misses = 0;
    l3CoralPlacements.successes = 0;
    l3CoralPlacements.misses = 0;
    l2CoralPlacements.successes = 0;
    l2CoralPlacements.misses = 0;
    l1CoralPlacements.successes = 0;
    l1CoralPlacements.misses = 0;
    netAlgaePlacements.successes = 0;
    netAlgaePlacements.misses = 0;
    processorAlgaeCount = 0;
    algaeOutOfReefCount = 0;
  }

  int calculateTotalPoints() {
    final l4Points = l4CoralPlacements.successes * 7;
    final l3Points = l3CoralPlacements.successes * 6;
    final l2Points = l2CoralPlacements.successes * 4;
    final l1Points = l1CoralPlacements.successes * 3;
    final netPoints = netAlgaePlacements.successes * 4;
    final processorPoints = processorAlgaeCount * 2;
    final leavePoints = (crossedAutoLine == true) ? 3 : 0;

    return l4Points + l3Points + l2Points + l1Points + netPoints +
        processorPoints + leavePoints;
  }

  int calculateCycles() {
    final l4Cycles = l4CoralPlacements.successes;
    final l3Cycles = l3CoralPlacements.successes;
    final l2Cycles = l2CoralPlacements.successes;
    final l1Cycles = l1CoralPlacements.successes;
    final netCycles = netAlgaePlacements.successes;
    final processorCycles = processorAlgaeCount;

    return l4Cycles + l3Cycles + l2Cycles + l1Cycles + netCycles +
        processorCycles;
  }

  String? validate() {
    if (crossedAutoLine == null) {
      return "Please select whether the robot crossed the auto line";
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      "crossedAutoLine": crossedAutoLine,
      "l4Placements": l4CoralPlacements.toMap(),
      "l3Placements": l3CoralPlacements.toMap(),
      "l2Placements": l2CoralPlacements.toMap(),
      "l1Placements": l1CoralPlacements.toMap(),
      "netAlgaePlacements": netAlgaePlacements.toMap(),
      "processorAlgaeCount": processorAlgaeCount,
      "algaeOutOfReefCount": algaeOutOfReefCount,
    };
  }
}

class TeleopScoutingReport {
  bool didDefend = false;

  final Placements l4CoralPlacements = Placements();
  final Placements l3CoralPlacements = Placements();
  final Placements l2CoralPlacements = Placements();
  final Placements l1CoralPlacements = Placements();

  late List<Placements> coralPlacements = [
    l1CoralPlacements,
    l2CoralPlacements,
    l3CoralPlacements,
    l4CoralPlacements,
  ];

  final Placements netAlgaePlacements = Placements();
  int processorAlgaeCount = 0;
  int algaeOutOfReefCount = 0;

  void reset() {
    didDefend = false;
    l4CoralPlacements.successes = 0;
    l4CoralPlacements.misses = 0;
    l3CoralPlacements.successes = 0;
    l3CoralPlacements.misses = 0;
    l2CoralPlacements.successes = 0;
    l2CoralPlacements.misses = 0;
    l1CoralPlacements.successes = 0;
    l1CoralPlacements.misses = 0;
    netAlgaePlacements.successes = 0;
    netAlgaePlacements.misses = 0;
    processorAlgaeCount = 0;
    algaeOutOfReefCount = 0;
  }

  int calculateTotalPoints() {
    final l4Points = l4CoralPlacements.successes * 5;
    final l3Points = l3CoralPlacements.successes * 4;
    final l2Points = l2CoralPlacements.successes * 3;
    final l1Points = l1CoralPlacements.successes * 2;
    final netPoints = netAlgaePlacements.successes * 4;
    final processorPoints = processorAlgaeCount * 2;

    return l4Points + l3Points + l2Points + l1Points + netPoints +
        processorPoints;
  }

  int calculateCycles() {
    final l4Cycles = l4CoralPlacements.successes;
    final l3Cycles = l3CoralPlacements.successes;
    final l2Cycles = l2CoralPlacements.successes;
    final l1Cycles = l1CoralPlacements.successes;
    final netCycles = netAlgaePlacements.successes;
    final processorCycles = processorAlgaeCount;

    return l4Cycles + l3Cycles + l2Cycles + l1Cycles + netCycles +
        processorCycles;
  }

  String? validate() {
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      "l4Placements": l4CoralPlacements.toMap(),
      "l3Placements": l3CoralPlacements.toMap(),
      "l2Placements": l2CoralPlacements.toMap(),
      "l1Placements": l1CoralPlacements.toMap(),
      "netAlgaePlacements": netAlgaePlacements.toMap(),
      "processorAlgaeCount": processorAlgaeCount,
      "algaeOutOfReefCount": algaeOutOfReefCount,
      "didDefend": didDefend,
    };
  }
}

class EndgameScoutingReport {
  bool? didTryToClimb;
  bool? didPark;
  bool? deepCage;
  bool? didManageToClimb;
  ClimbFailureReason? climbFailureReason;

  void reset() {
    didTryToClimb = null;
    didPark = null;
    deepCage = null;
    didManageToClimb = null;
    climbFailureReason = null;
  }

  int calculateTotalPoints() {
    if (didTryToClimb == true) {
      if (didManageToClimb == true) {
        return (deepCage == true) ? 12 : 6;
      }

      return 2;
    }

    if (didPark == true) return 2;
    return 0;
  }

  String? validate() {
    if (didTryToClimb == null) {
      return "Please select whether the robot tried to climb";
    }
    if (didTryToClimb == false) {
      if (didPark == null) return "Please select whether the robot parked";
      return null;
    } else {
      if (deepCage == null) return "Please select the cage type";
      if (didManageToClimb == null) {
        return "Please select whether the robot managed to climb";
      }
      if (didManageToClimb == false && climbFailureReason == null) {
        return "Please select a climb failure reason";
      }
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "didTryToClimb": didTryToClimb,
      "didPark": didPark,
      "deepCage": deepCage,
      "didManageToClimb": didManageToClimb,
      "climbFailureReason": climbFailureReason?.toNormalText(),
    };
  }
}

class PostgameReport {
  bool? didCollectAlgaeFromGround;
  String? comments;

  void reset() {
    didCollectAlgaeFromGround = null;
    comments = null;
  }

  String? validate() {
    if (didCollectAlgaeFromGround == null) {
      return "Please select whether the team collected algae from the ground";
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      "didCollectAlgaeFromGround": didCollectAlgaeFromGround,
      "comments": comments,
    };
  }
}

enum ClimbFailureReason {
  gotHit,
  noTime,
  fell,
  other;

  String toNormalText() {
    final spaced = name.replaceAllMapped(
      RegExp(r"([A-Z])"),
          (m) => " ${m.group(1)}",
    );
    return spaced[0].toUpperCase() + spaced.substring(1);
  }
}
