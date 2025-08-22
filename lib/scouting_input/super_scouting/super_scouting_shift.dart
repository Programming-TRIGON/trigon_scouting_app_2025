import 'package:flutter/material.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_shift.dart';
import 'package:trigon_scouting_app_2025/utilities/tba_handler.dart';

class SuperScoutingShift extends ScoutingShift {
  final String matchKey;
  final List<FRCTeam> scoutedAlliance;
  final bool isBlueAlliance;

  SuperScoutingShift({
    required this.matchKey,
    required this.scoutedAlliance,
    required this.isBlueAlliance,
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
      'scoutedAlliance': scoutedAlliance.map((team) => team.toMap()).toList(),
      'isBlueAlliance': isBlueAlliance,
      'didScout': didScout,
    };
  }

  factory SuperScoutingShift.fromMap(Map<String, dynamic> map) {
    return SuperScoutingShift(
      matchKey: map['matchKey'] as String,
      scoutedAlliance: (map['scoutedAlliance'] as List)
          .map((map) => FRCTeam.fromMap(map))
          .toList(),
      isBlueAlliance: map['isBlueAlliance'] as bool,
      didScout: map['didScout'] as bool,
    );
  }

  @override
  Widget buildScheduleWidget() {
    return Card(
      color: didScout ? Colors.green : Colors.grey[850],
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.schedule, color: Colors.blue[400]),
        title: Text(
          getMatchName(),
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          isBlueAlliance ? "Blue Alliance" : "Red Alliance",
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
