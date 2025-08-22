import 'package:flutter/cupertino.dart';

abstract class ScoutingShift {
  final bool didScout;

  ScoutingShift({
    required this.didScout
  });

  String getMatchName() {
    return "${getMatchType()} ${getMatchNumber()}";
  }

  int getMatchNumber() {
    String? matchKey = getMatchKey();
    if (matchKey == null) return 0;

    if (getMatchTypeOrder() > 1) {
      return getSetNumber();
    }
    final match = RegExp(r'\d+$').firstMatch(matchKey);
    if (match != null) return int.tryParse(match.group(0)!) ?? 0;
    return 0;
  }

  /// Set number for Playoffs/Finals (e.g., "sf2m1" → 2)
  int getSetNumber() {
    String? matchKey = getMatchKey();
    if (matchKey == null) return 0;

    final match = RegExp(r'^[a-z]+(\d+)m\d+$').firstMatch(matchKey);
    if (match != null) return int.tryParse(match.group(1)!) ?? 0;
    return 0;
  }

  int getMatchTypeOrder() {
    switch (getMatchType()) {
      case "Practice":
        return 0;
      case "Qualification":
        return 1;
      case "Playoffs":
        return 2;
      case "Finals":
        return 3;
      default:
        return -1;
    }
  }

  String? getMatchType() {
    String? matchKey = getMatchKey();
    if (matchKey == null) return null;

    if (matchKey.startsWith('p')) return "Practice";
    if (matchKey.startsWith('qm')) return "Qualification";
    if (matchKey.startsWith('sf')) return "Playoffs";
    if (matchKey.startsWith('f')) return "Finals";

    return "Unknown";
  }

  String? getMatchKey() {
    return null;
  }

  Widget buildScheduleWidget();

  Map<String, dynamic> toMap();
}