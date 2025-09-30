import "dart:async";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/foundation.dart";
import "package:trigon_scouting_app_2025/scouting_input/providers/scouted_competition/scouted_competition.dart";
import "package:trigon_scouting_app_2025/utilities/tba_handler.dart";

import "package:trigon_scouting_app_2025/utilities/firebase_handler.dart";

class ScoutedCompetitionProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentReference<Map<String, dynamic>> scoutedCompetitionDoc = _firestore
      .collection("competitions")
      .doc("scoutedCompetition"); 

  ScoutedCompetition? scoutedCompetition;
  StreamSubscription<DocumentSnapshot>? _scoutedCompetitionSubscriber;

  ScoutedCompetitionProvider() {
    FirebaseHandler.getScoutedCompetition().then(
      (value) => scoutedCompetition = value,
    );
    listenToRole();
  }

  FRCTeam? getScoutedTeamInGameScoutingMatch(String uid, String matchKey) {
    return scoutedCompetition?.allScoutingShifts.gameScoutingShifts?[uid]
        ?.firstWhere((shift) => shift.matchKey == matchKey).scoutedTeam;
  }

  bool? getScoutedAllianceColorInSuperScoutingMatch(String uid, String matchKey) {
    return scoutedCompetition?.allScoutingShifts.superScoutingShifts?[uid]
        ?.firstWhere((shift) => shift.matchKey == matchKey).isBlueAlliance;
  }

  List<FRCTeam>? getTeamsInMatchAlliance(String? matchKey, bool? isBlueAlliance) {
    if (matchKey == null || isBlueAlliance == null) return null;
    final match = scoutedCompetition?.matches.firstWhere((match) => match.matchKey == matchKey);
    if (match == null) return null;
    return isBlueAlliance ? match.blueTeams : match.redTeams;
  }

  String? getTeamNameFromNumber(int? teamNumber) {
    return scoutedCompetition?.teams.where((team) => team.teamID == teamNumber).firstOrNull?.name;
  }

  List<int>? getAvailableGameScoutingMatchNumbers(String uid, String matchType) {
    return scoutedCompetition?.allScoutingShifts.gameScoutingShifts?[uid]
        ?.where((shift) => shift.getMatchType() == matchType)
        .map((shift) => shift.getMatchNumber()).toList();
  }

  List<int>? getAvailableSuperScoutingMatchNumbers(String uid, String matchType) {
    return scoutedCompetition?.allScoutingShifts.superScoutingShifts?[uid]
        ?.where((shift) => shift.getMatchType() == matchType)
        .map((shift) => shift.getMatchNumber()).toList();
  }

  void updateBoundingScores(int robotScore) {
    if (scoutedCompetition == null) return;

    if (robotScore > scoutedCompetition!.maximumScore) {
      scoutedCompetition!.maximumScore = robotScore as double;
      scoutedCompetitionDoc.set(scoutedCompetition!.toMap());
    }
    if (robotScore < scoutedCompetition!.minimumScore) {
      scoutedCompetition!.minimumScore = robotScore as double;
      scoutedCompetitionDoc.set(scoutedCompetition!.toMap());
    }
  }
  
  void markGameScoutingShiftScouted(String? uid, String? matchKey) {
    if (scoutedCompetition == null) return;

    scoutedCompetition!.allScoutingShifts.gameScoutingShifts?[uid]?.firstWhere((shift) => shift.matchKey == matchKey).didScout = true;
    scoutedCompetitionDoc.set(scoutedCompetition!.toMap());
  }

  void markSuperScoutingShiftScouted(String? uid, String? matchKey) {
    if (scoutedCompetition == null) return;

    scoutedCompetition!.allScoutingShifts.superScoutingShifts?[uid]?.firstWhere((shift) => shift.matchKey == matchKey).didScout = true;
    scoutedCompetitionDoc.set(scoutedCompetition!.toMap());
  }

  void listenToRole() {
    notifyListeners();

    _scoutedCompetitionSubscriber = scoutedCompetitionDoc
        .snapshots()
        .listen(onDocumentSnapshot);
  }

  void onDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc.exists && doc.data() != null) {
      scoutedCompetition = ScoutedCompetition.fromMap(
        Map<String, dynamic>.from(doc.data()!),
      );
    } else {
      scoutedCompetition = null;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _scoutedCompetitionSubscriber?.cancel();
    super.dispose();
  }
}
