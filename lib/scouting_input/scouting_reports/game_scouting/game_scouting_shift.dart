import 'package:flutter/material.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/scouting_shift.dart';
import 'package:trigon_scouting_app_2025/utilities/tba_handler.dart';

class GameScoutingShift extends ScoutingShift {
  final String matchKey;
  final FRCTeam scoutedTeam;

  GameScoutingShift({
    required this.matchKey,
    required this.scoutedTeam,
    required super.didScout,
  });

  @override
  String getMatchKey() {
    return matchKey;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'matchKey': matchKey,
      'scoutedTeam': scoutedTeam.toMap(),
      'didScout': didScout,
    };
  }

  factory GameScoutingShift.fromMap(Map<String, dynamic> map) {
    return GameScoutingShift(
      matchKey: map['matchKey'] as String,
      scoutedTeam: FRCTeam.fromMap(map['scoutedTeam']),
      didScout: map['didScout'] as bool,
    );
  }

  @override
  Widget buildScheduleWidget() {
    return Card(
      key: globalKey,
      color: didScout ? Colors.green : Colors.grey[850],
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.schedule, color: Colors.blue[400]),
        title: Text(getMatchName(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(scoutedTeam.teamText, style: const TextStyle(color: Colors.white, fontSize: 14))
      ),
    );
  }
}
