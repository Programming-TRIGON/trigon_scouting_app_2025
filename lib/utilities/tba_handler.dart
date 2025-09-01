import 'dart:convert';
import 'package:http/http.dart' as http;

class TBAHandler {
  static String apiKey = "4tkqQPrngugTm7YMAf5FjqDaz14cEDScelswSxhzR1SKnl42NugabiqP7LPdPnw4";

  static Future<FRCCompetition> getCompetition(String competitionKey) async {
    try {
      final teams = await getTeamsInCompetition(competitionKey);
      final matches = await getMatchesInCompetition(competitionKey, teams);

      return FRCCompetition(
        competitionKey: competitionKey,
        teams: teams,
        matches: matches,
      );
    } catch (e) {
      throw Exception('Failed to fetch competition $competitionKey: $e');
    }
  }

  static Future<List<FRCTeam>> getTeamsInCompetition(
      String competitionKey) async {
    final url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/event/$competitionKey/teams');

    final response = await http.get(
      url,
      headers: {'X-TBA-Auth-Key': apiKey},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch teams: ${response.statusCode}');
    }

    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((teamData) {
      return FRCTeam(
        teamID: teamData['team_number'],
        name: teamData['nickname'] ?? teamData['name'],
      );
    }).toList();
  }

  static Future<List<FRCMatch>> getMatchesInCompetition(
      String competitionKey, List<FRCTeam> allTeams) async {
    final url = Uri.parse('https://www.thebluealliance.com/api/v3/event/$competitionKey/matches');

    final response = await http.get(
      url,
      headers: {'X-TBA-Auth-Key': apiKey},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch matches: ${response.statusCode}');
    }

    final List<dynamic> jsonData = jsonDecode(response.body);

    List<FRCMatch> matches = jsonData.map((matchData) {
      List<FRCTeam> blueTeams = [];
      List<FRCTeam> redTeams = [];

      for (var teamKey in matchData['alliances']['blue']['team_keys']) {
        int teamNumber = int.parse(teamKey.replaceAll('frc', ''));
        final team = allTeams.firstWhere(
              (t) => t.teamID == teamNumber,
          orElse: () => FRCTeam(teamID: teamNumber, name: 'Unknown'),
        );
        blueTeams.add(team);
      }

      for (var teamKey in matchData['alliances']['red']['team_keys']) {
        int teamNumber = int.parse(teamKey.replaceAll('frc', ''));
        final team = allTeams.firstWhere(
              (t) => t.teamID == teamNumber,
          orElse: () => FRCTeam(teamID: teamNumber, name: 'Unknown'),
        );
        redTeams.add(team);
      }

      return FRCMatch(
        matchKey: matchData['key'].replaceFirst('${competitionKey}_', ''),
        blueTeams: blueTeams,
        redTeams: redTeams,
        time: matchData['time'] != null
            ? DateTime.fromMillisecondsSinceEpoch(matchData['time'] * 1000, isUtc: true).toLocal()
            : null,
      );
    }).toList();

    // sort like before
    matches.sort((a, b) {
      final typeCmp = a.matchTypeOrder.compareTo(b.matchTypeOrder);
      if (typeCmp != 0) return typeCmp;
      final setCmp = a.setNumber.compareTo(b.setNumber);
      if (setCmp != 0) return setCmp;
      return a.matchNumber.compareTo(b.matchNumber);
    });

    return matches;
  }
}

class FRCTeam {
  final int teamID;
  final String name;

  FRCTeam({required this.teamID, required this.name});

  String get teamText => "$teamID $name";

  Map<String, dynamic> toMap() {
    return {
      'teamID': teamID,
      'name': name,
    };
  }

  factory FRCTeam.fromMap(Map<String, dynamic> map) {
    return FRCTeam(
      teamID: map['teamID'] as int,
      name: map['name'] as String,
    );
  }
}

class FRCMatch {
  final String matchKey; // raw key: "qm13", "sf2m1", "f1m2"
  final List<FRCTeam> blueTeams;
  final List<FRCTeam> redTeams;
  final DateTime? time;

  FRCMatch({
    required this.matchKey,
    required this.blueTeams,
    required this.redTeams,
    this.time,
  });

  static String? toMatchKey(String? matchType, String? matchNumber) {
    if (matchType == null|| matchNumber == null) return null;

    switch (matchType.toLowerCase()) {
      case "practice":
        return "p$matchNumber";
      case "qualification":
        return "qm$matchNumber";
      case "playoffs":
        return "sf${matchNumber}m1";
      case "finals":
        return "f1m$matchNumber";
      default:
        return null;
    }
  }

  static String toMatchName(String matchKey) {
    return "${toMatchType(matchKey)} ${toMatchNumber(matchKey)}";
  }

  static int toMatchNumber(String? matchKey) {
    if (matchKey == null) return 0;

    final matchType = toMatchType(matchKey);
    if (matchType == "Playoffs") {
      return toSetNumber(matchKey);
    }
    final match = RegExp(r'\d+$').firstMatch(matchKey);
    if (match != null) return int.tryParse(match.group(0)!) ?? 0;
    return 0;
  }

  /// Set number for Playoffs/Finals (e.g., "sf2m1" → 2)
  static int toSetNumber(String? matchKey) {
    if (matchKey == null) return 0;

    final match = RegExp(r'^[a-z]+(\d+)m\d+$').firstMatch(matchKey);
    if (match != null) return int.tryParse(match.group(1)!) ?? 0;
    return 0;
  }

  static int toMatchTypeOrder(String? matchType) {
    switch (matchType) {
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

  static String? toMatchType(String? matchKey) {
    if (matchKey == null) return null;

    if (matchKey.startsWith('p')) return "Practice";
    if (matchKey.startsWith('qm')) return "Qualification";
    if (matchKey.startsWith('sf')) return "Playoffs";
    if (matchKey.startsWith('f')) return "Finals";

    return "Unknown";
  }

  int get matchNumber => toMatchNumber(matchKey);
  int get setNumber => toSetNumber(matchKey);
  int get matchTypeOrder => toMatchTypeOrder(toMatchType(matchKey));
  String get matchType => toMatchType(matchKey) ?? "Unknown";
  String get matchName => toMatchName(matchKey);

  Map<String, dynamic> toMap() {
    return {
      'matchKey': matchKey,
      'blueTeams': blueTeams.map((t) => t.toMap()).toList(),
      'redTeams': redTeams.map((t) => t.toMap()).toList(),
      'time': time?.toIso8601String(),
    };
  }

  factory FRCMatch.fromMap(Map<String, dynamic> map) {
    return FRCMatch(
      matchKey: map['matchKey'] as String,
      blueTeams: (map['blueTeams'] as List)
          .map((t) => FRCTeam.fromMap(Map<String, dynamic>.from(t)))
          .toList(),
      redTeams: (map['redTeams'] as List)
          .map((t) => FRCTeam.fromMap(Map<String, dynamic>.from(t)))
          .toList(),
      time: map['time'] != null ? DateTime.parse(map['time'] as String) : null,
    );
  }
}

class FRCCompetition {
  final String competitionKey;
  final List<FRCTeam> teams;
  final List<FRCMatch> matches;

  FRCCompetition({
    required this.competitionKey,
    required this.teams,
    required this.matches,
  });

  FRCMatch? getMatchByKey(String matchKey) {
    for (FRCMatch match in matches) {
      if (match.matchKey == matchKey) return match;
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'competitionKey': competitionKey,
      'teams': teams.map((t) => t.toMap()).toList(),
      'matches': matches.map((m) => m.toMap()).toList(),
    };
  }

  factory FRCCompetition.fromMap(Map<String, dynamic> map) {
    return FRCCompetition(
      competitionKey: map['competitionKey'] as String,
      teams: (map['teams'] as List)
          .map((t) => FRCTeam.fromMap(Map<String, dynamic>.from(t)))
          .toList(),
      matches: (map['matches'] as List)
          .map((m) => FRCMatch.fromMap(Map<String, dynamic>.from(m)))
          .toList(),
    );
  }
}
