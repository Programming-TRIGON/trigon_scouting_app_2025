import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_shift.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/picture_scouting/picture_scouting_shift.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/super_scouting/super_scouting_shift.dart';
import 'package:trigon_scouting_app_2025/utilities/tba_handler.dart';

class ScoutedCompetition extends FRCCompetition {
  final Map<String, List<GameScoutingShift>?>? gameScoutingShifts;
  final Map<String, List<SuperScoutingShift>?>? superScoutingShifts;
  final Map<String, List<PictureScoutingShift>?>? pictureScoutingShifts;
  double maximumScore, minimumScore;

  ScoutedCompetition({
    required super.competitionID,
    required super.teams,
    required super.matches,
    required this.gameScoutingShifts,
    required this.superScoutingShifts,
    required this.pictureScoutingShifts,
    required this.maximumScore,
    required this.minimumScore
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'competitionID': competitionID,
      'teams': teams.map((team) => team.toMap()).toList(),
      'matches': matches.map((match) => match.toMap()).toList(),
      'gameScoutingShifts': gameScoutingShifts?.map(
              (uid, shift) => MapEntry(uid, shift?.map((shift) => shift.toMap()).toList())
      ),
      'superScoutingShifts' : superScoutingShifts?.map(
              (uid, shift) => MapEntry(uid, shift?.map((shift) => shift.toMap()).toList())
      ),
      'pictureScoutingShifts' : pictureScoutingShifts?.map(
              (uid, shift) => MapEntry(uid, shift?.map((shift) => shift.toMap()).toList())
      ),
      'maximumScore': maximumScore,
      'minimumScore': minimumScore,
    };
  }

  @override
  factory ScoutedCompetition.fromMap(Map<String, dynamic> map) {
    return ScoutedCompetition(
      competitionID: map['competitionID'] as String,
      teams: (map['teams'] as List)
        .map((t) => FRCTeam.fromMap(Map<String, dynamic>.from(t)))
        .toList(),
      matches: (map['matches'] as List)
        .map((m) => FRCMatch.fromMap(Map<String, dynamic>.from(m)))
        .toList(),
      gameScoutingShifts: (map['gameScoutingShifts'] as Map)
        .map((uid, shiftsList) => MapEntry(
          uid as String,
          shiftsList == null ? null : List<Map<String, dynamic>>.from(shiftsList).map((shiftMap) => GameScoutingShift.fromMap(shiftMap)).toList()
        )
      ),
      superScoutingShifts: (map['superScoutingShifts'] as Map)
        .map((uid, shiftsList) => MapEntry(
          uid as String,
          shiftsList == null ? null : List<Map<String, dynamic>>.from(shiftsList).map((shiftMap) => SuperScoutingShift.fromMap(shiftMap)).toList()
        )
      ),
      pictureScoutingShifts: (map['pictureScoutingShifts'] as Map)
        .map((uid, shiftsList) => MapEntry(
          uid as String,
          shiftsList == null ? null : List<Map<String, dynamic>>.from(shiftsList).map((shiftMap) => PictureScoutingShift.fromMap(shiftMap)).toList()
        )
      ),
      maximumScore: (map['maximumScore'] as num).toDouble(),
      minimumScore: (map['minimumScore'] as num).toDouble()
    );
  }
}
