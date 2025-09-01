class ScoutingUnit {
  final String name;
  String? unitHeadUID, scouter1UID, scouter2UID, scouter3UID;

  ScoutingUnit({
    required this.name,
    this.unitHeadUID,
    this.scouter1UID,
    this.scouter2UID,
    this.scouter3UID,
  });

  List<String?> getScoutersUIDs() {
    return [
      unitHeadUID,
      scouter1UID,
      scouter2UID,
      scouter3UID,
    ].whereType<String>().toList();
  }

  static List<ScoutingUnit> scoutingUnitsListFromMap(Map<String, dynamic> map) {
    return map.entries.map((entry) => ScoutingUnit.fromMap(entry.value)).toList();
  }

  static Map<String, dynamic> scoutingUnitsListToMap(List<ScoutingUnit>? units) {
    if (units == null) return {};
    final Map<String, dynamic> map = {};
    for (var unit in units) {
      if (unit.name == null) continue;
      map[unit.name!] = unit.toMap();
    }
    return map;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'unitHeadUID': unitHeadUID,
      'scouter1UID': scouter1UID,
      'scouter2UID': scouter2UID,
      'scouter3UID': scouter3UID,
    };
  }

  factory ScoutingUnit.fromMap(Map<String, dynamic> map) {
    return ScoutingUnit(
      name: map['name'] as String,
      unitHeadUID: map['unitHeadUID'] as String,
      scouter1UID: map['scouter1UID'] as String,
      scouter2UID: map['scouter2UID'] as String,
      scouter3UID: map['scouter3UID'] as String,
    );
  }
}
