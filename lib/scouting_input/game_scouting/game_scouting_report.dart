class GameScoutingReport {
  final String scouterUID;

  final PregameScoutingReport pregameReport;
  final AutoScoutingReport autoReport;
  final TeleopScoutingReport teleopReport;
  final EndgameScoutingReport endgameReport;

  const GameScoutingReport({
    required this.scouterUID,
    required this.pregameReport,
    required this.autoReport,
    required this.teleopReport,
    required this.endgameReport,
  });

  GameScoutingReport.withUID(this.scouterUID)
    : pregameReport = PregameScoutingReport(),
      autoReport = AutoScoutingReport(),
      teleopReport = TeleopScoutingReport(),
      endgameReport = EndgameScoutingReport();

  GameScoutingReport copyWith({
    PregameScoutingReport? pregameReport,
    AutoScoutingReport? autoReport,
    TeleopScoutingReport? teleopReport,
    EndgameScoutingReport? endgameReport,
  }) {
    return GameScoutingReport(
      scouterUID: scouterUID,
      pregameReport: pregameReport ?? this.pregameReport,
      autoReport: autoReport ?? this.autoReport,
      teleopReport: teleopReport ?? this.teleopReport,
      endgameReport: endgameReport ?? this.endgameReport,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'GameScouting': {
        'Pregame': pregameReport.toMap(),
        'Auto': autoReport.toMap(),
        'Teleop': teleopReport.toMap(),
        'Endgame': endgameReport.toMap(),
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
    return {'successes': successes, 'misses': misses};
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
      'showedUp': showedUp,
      'startingPosition': startingPosition,
      'didOverrideSelection' : didOverrideSelection
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

  String? validate() {
    if (crossedAutoLine == null) {
      return "Please select whether the robot crossed the auto line";
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'crossedAutoLine': crossedAutoLine,
      'l4Placements': l4CoralPlacements.toMap(),
      'l3Placements': l3CoralPlacements.toMap(),
      'l2Placements': l2CoralPlacements.toMap(),
      'l1Placements': l1CoralPlacements.toMap(),
      'netAlgaePlacements': netAlgaePlacements.toMap(),
      'processorAlgaeCount': processorAlgaeCount,
      'algaeOutOfReefCount': algaeOutOfReefCount,
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

  String? validate() {
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'l4Placements': l4CoralPlacements.toMap(),
      'l3Placements': l3CoralPlacements.toMap(),
      'l2Placements': l2CoralPlacements.toMap(),
      'l1Placements': l1CoralPlacements.toMap(),
      'netAlgaePlacements': netAlgaePlacements.toMap(),
      'processorAlgaeCount': processorAlgaeCount,
      'algaeOutOfReefCount': algaeOutOfReefCount,
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
      RegExp(r'([A-Z])'),
      (m) => ' ${m.group(1)}',
    );
    return spaced[0].toUpperCase() + spaced.substring(1);
  }
}

class EndgameScoutingReport {
  bool? didTryToClimb;
  bool? didPark;
  bool? deepCage;
  bool? didManageToClimb;
  ClimbFailureReason? climbFailureReason;

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
      'didTryToClimb': didTryToClimb,
      'didPark': didPark,
      'deepCage': deepCage,
      'didManageToClimb': didManageToClimb,
      'climbFailureReason': climbFailureReason?.toNormalText(),
    };
  }
}
