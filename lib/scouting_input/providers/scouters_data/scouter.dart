class Scouter {
  final String uid;
  final String name;
  bool isGameScouter, isSuperScouter, isPictureScouter;
  bool doesComeToDay1, doesComeToDay2;

  Scouter({
    required this.uid,
    required this.name,
    required this.isGameScouter,
    required this.isSuperScouter,
    required this.isPictureScouter,
    required this.doesComeToDay1,
    required this.doesComeToDay2,
  });

  static List<Scouter> scoutersListFromMap(List list) {
    return list.map((scouterMap) => Scouter.fromMap(scouterMap)).toList();
  }

  static List<Map<String, dynamic>> scoutersListToMap(List<Scouter>? scouters) {
    if (scouters == null) return [];
    return scouters.map((scouter) => scouter.toMap()).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'isGameScouter': isGameScouter,
      'isSuperScouter': isSuperScouter,
      'isPictureScouter': isPictureScouter,
      'doesComeToDay1': doesComeToDay1,
      'doesComeToDay2': doesComeToDay2,
    };
  }

  factory Scouter.fromMap(Map<String, dynamic> map) {
    return Scouter(
      uid: map['uid'] as String,
      name: map['name'] as String,
      isGameScouter: map['isGameScouter'] as bool,
      isSuperScouter: map['isSuperScouter'] as bool,
      isPictureScouter: map['isPictureScouter'] as bool,
      doesComeToDay1: map['doesComeToDay1'] as bool,
      doesComeToDay2: map['doesComeToDay2'] as bool,
    );
  }
}