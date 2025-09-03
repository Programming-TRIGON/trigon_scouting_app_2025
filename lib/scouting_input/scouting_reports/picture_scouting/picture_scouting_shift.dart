import 'package:flutter/material.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/scouting_shift.dart';
import 'package:trigon_scouting_app_2025/utilities/tba_handler.dart';

class PictureScoutingShift extends ScoutingShift {
  final FRCTeam scoutedTeam;

  PictureScoutingShift({required this.scoutedTeam, required super.didScout});

  @override
  Map<String, dynamic> toMap() {
    return {'scoutedTeam': scoutedTeam.toMap(), 'didScout': didScout};
  }

  @override
  factory PictureScoutingShift.fromMap(Map<String, dynamic> map) {
    return PictureScoutingShift(
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
        leading: Icon(Icons.camera_alt, color: Colors.blue[400]),
        title: Text(
          scoutedTeam.teamText,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
