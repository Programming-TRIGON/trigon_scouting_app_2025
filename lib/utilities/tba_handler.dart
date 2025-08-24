import 'dart:convert';
import 'package:http/http.dart' as http;

class TBAHandler {
  static String apiKey = "4tkqQPrngugTm7YMAf5FjqDaz14cEDScelswSxhzR1SKnl42NugabiqP7LPdPnw4";

  static Future<FRCCompetition> getCompetition(String competitionID) async {
    try {
      final teams = await getTeamsInCompetition(competitionID);
      final matches = await getMatchesInCompetition(competitionID, teams);

      return FRCCompetition(
        competitionID: competitionID,
        teams: teams,
        matches: matches,
      );
    } catch (e) {
      throw Exception('Failed to fetch competition $competitionID: $e');
    }
  }

  static Future<List<FRCTeam>> getTeamsInCompetition(
      String competitionID) async {
    final url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/event/$competitionID/teams');

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
      String competitionID, List<FRCTeam> allTeams) async {
    final url = Uri.parse('https://www.thebluealliance.com/api/v3/event/$competitionID/matches');

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
        matchKey: matchData['key'].replaceFirst('${competitionID}_', ''),
        blueTeams: blueTeams,
        redTeams: redTeams,
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

  FRCMatch({
    required this.matchKey,
    required this.blueTeams,
    required this.redTeams,
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

  /// Extract type: "Practice", "Qualification", "Playoffs", "Finals"
  String get matchType {
    if (matchKey.startsWith('p')) return "Practice";
    if (matchKey.startsWith('qm')) return "Qualification";
    if (matchKey.startsWith('sf')) return "Playoffs";
    if (matchKey.startsWith('f')) return "Finals";
    return "Unknown";
  }

  /// Sorting priority
  int get matchTypeOrder {
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
        return 99;
    }
  }

  /// Match number (e.g., "qm13" → 13, "sf2m1" → 1)
  int get matchNumber {
    if (matchTypeOrder > 1) {
      return setNumber;
    }
    final match = RegExp(r'\d+$').firstMatch(matchKey);
    if (match != null) return int.tryParse(match.group(0)!) ?? 0;
    return 0;
  }

  /// Set number for Playoffs/Finals (e.g., "sf2m1" → 2)
  int get setNumber {
    final match = RegExp(r'^[a-z]+(\d+)m\d+$').firstMatch(matchKey);
    if (match != null) return int.tryParse(match.group(1)!) ?? 0;
    return 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'matchKey': matchKey,
      'blueTeams': blueTeams.map((t) => t.toMap()).toList(),
      'redTeams': redTeams.map((t) => t.toMap()).toList(),
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
    );
  }
}

class FRCCompetition {
  final String competitionID;
  final List<FRCTeam> teams;
  final List<FRCMatch> matches;

  FRCCompetition({
    required this.competitionID,
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
      'competitionID': competitionID,
      'teams': teams.map((t) => t.toMap()).toList(),
      'matches': matches.map((m) => m.toMap()).toList(),
    };
  }

  factory FRCCompetition.fromMap(Map<String, dynamic> map) {
    return FRCCompetition(
      competitionID: map['competitionID'] as String,
      teams: (map['teams'] as List)
          .map((t) => FRCTeam.fromMap(Map<String, dynamic>.from(t)))
          .toList(),
      matches: (map['matches'] as List)
          .map((m) => FRCMatch.fromMap(Map<String, dynamic>.from(m)))
          .toList(),
    );
  }
}
