import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_shift.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/picture_scouting/picture_scouting_shift.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/super_scouting/super_scouting_shift.dart';
import 'package:trigon_scouting_app_2025/utilities/tba_handler.dart';

class ScoutedCompetition extends FRCCompetition {
  AllScoutingShifts allScoutingShifts;
  double maximumScore, minimumScore;

  ScoutedCompetition({
    required super.competitionKey,
    required super.teams,
    required super.matches,
    required this.allScoutingShifts,
    required this.maximumScore,
    required this.minimumScore,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'competitionKey': competitionKey,
      'teams': teams.map((team) => team.toMap()).toList(),
      'matches': matches.map((match) => match.toMap()).toList(),
      'scoutingShifts': allScoutingShifts.toMap(),
      'maximumScore': maximumScore,
      'minimumScore': minimumScore,
    };
  }

  @override
  factory ScoutedCompetition.fromMap(Map<String, dynamic> map) {
    return ScoutedCompetition(
      competitionKey: map['competitionKey'] as String,
      teams: (map['teams'] as List)
          .map((t) => FRCTeam.fromMap(Map<String, dynamic>.from(t)))
          .toList(),
      matches: (map['matches'] as List)
          .map((m) => FRCMatch.fromMap(Map<String, dynamic>.from(m)))
          .toList(),
      allScoutingShifts: AllScoutingShifts.fromMap(
        Map<String, dynamic>.from(map['scoutingShifts']),
      ),
      maximumScore: (map['maximumScore'] as num).toDouble(),
      minimumScore: (map['minimumScore'] as num).toDouble(),
    );
  }
}

class AllScoutingShifts {
  final Map<String, List<GameScoutingShift>?>? gameScoutingShifts;
  final Map<String, List<SuperScoutingShift>?>? superScoutingShifts;
  final Map<String, List<PictureScoutingShift>?>? pictureScoutingShifts;

  const AllScoutingShifts({
    this.gameScoutingShifts = const {},
    this.superScoutingShifts = const {},
    this.pictureScoutingShifts = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'gameScoutingShifts': gameScoutingShifts?.map(
        (uid, shift) =>
            MapEntry(uid, shift?.map((shift) => shift.toMap()).toList()),
      ),
      'superScoutingShifts': superScoutingShifts?.map(
        (uid, shift) =>
            MapEntry(uid, shift?.map((shift) => shift.toMap()).toList()),
      ),
      'pictureScoutingShifts': pictureScoutingShifts?.map(
        (uid, shift) =>
            MapEntry(uid, shift?.map((shift) => shift.toMap()).toList()),
      ),
    };
  }

  factory AllScoutingShifts.fromMap(Map<String, dynamic> map) {
    return AllScoutingShifts(
      gameScoutingShifts: (map['gameScoutingShifts'] as Map).map(
        (uid, shiftsList) => MapEntry(
          uid as String,
          shiftsList == null
              ? null
              : List<Map<String, dynamic>>.from(shiftsList)
                    .map((shiftMap) => GameScoutingShift.fromMap(shiftMap))
                    .toList(),
        ),
      ),
      superScoutingShifts: (map['superScoutingShifts'] as Map).map(
        (uid, shiftsList) => MapEntry(
          uid as String,
          shiftsList == null
              ? null
              : List<Map<String, dynamic>>.from(shiftsList)
                    .map((shiftMap) => SuperScoutingShift.fromMap(shiftMap))
                    .toList(),
        ),
      ),
      pictureScoutingShifts: (map['pictureScoutingShifts'] as Map).map(
        (uid, shiftsList) => MapEntry(
          uid as String,
          shiftsList == null
              ? null
              : List<Map<String, dynamic>>.from(shiftsList)
                    .map((shiftMap) => PictureScoutingShift.fromMap(shiftMap))
                    .toList(),
        ),
      ),
    );
  }
}
