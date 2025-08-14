import 'dart:convert';
import 'package:http/http.dart' as http;

class TBAHandler {
  static String apiKey = "4tkqQPrngugTm7YMAf5FjqDaz14cEDScelswSxhzR1SKnl42NugabiqP7LPdPnw4";

  static Future<FRCCompetition> getCompetition(String competitionID) async {
    try {
      final results = await Future.wait([
        getTeamsInCompetition(competitionID),
        getMatchesInCompetition(competitionID),
      ]);

      final List<FRCTeam> teams = results[0] as List<FRCTeam>;
      final List<FRCMatch> matches = results[1] as List<FRCMatch>;

      return FRCCompetition(
        competitionID: competitionID,
        teams: teams,
        matches: matches,
      );
    } catch (e) {
      throw Exception('Failed to fetch competition $competitionID: $e');
    }
  }

  static Future<List<FRCTeam>> getTeamsInCompetition(String competitionID) async {
    final url = Uri.parse('https://www.thebluealliance.com/api/v3/event/$competitionID/teams');

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

  static Future<List<FRCMatch>> getMatchesInCompetition(String competitionID) async {
    final url = Uri.parse('https://www.thebluealliance.com/api/v3/event/$competitionID/matches');

    final response = await http.get(
      url,
      headers: {'X-TBA-Auth-Key': apiKey},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch matches: ${response.statusCode}');
    }

    final List<dynamic> jsonData = jsonDecode(response.body);

    return jsonData.map((matchData) {
      List<FRCTeam> blueTeams = [];
      List<FRCTeam> redTeams = [];

      for (var teamKey in matchData['alliances']['blue']['team_keys']) {
        int teamNumber = int.parse(teamKey.replaceAll('frc', ''));
        blueTeams.add(FRCTeam(teamID: teamNumber, name: ''));
      }

      for (var teamKey in matchData['alliances']['red']['team_keys']) {
        int teamNumber = int.parse(teamKey.replaceAll('frc', ''));
        redTeams.add(FRCTeam(teamID: teamNumber, name: ''));
      }

      return FRCMatch(
        matchID: matchData['key'].replaceFirst('${competitionID}_', ''),
        blueTeams: blueTeams,
        redTeams: redTeams,
      );
    }).toList();
  }
}

class FRCTeam {
  final int teamID;
  final String name;

  FRCTeam({required this.teamID, required this.name});

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
  final String matchID;
  final List<FRCTeam> blueTeams;
  final List<FRCTeam> redTeams;

  FRCMatch({
    required this.matchID,
    required this.blueTeams,
    required this.redTeams,
  });

  Map<String, dynamic> toMap() {
    return {
      'matchID': matchID,
      'blueTeams': blueTeams.map((t) => t.toMap()).toList(),
      'redTeams': redTeams.map((t) => t.toMap()).toList(),
    };
  }

  factory FRCMatch.fromMap(Map<String, dynamic> map) {
    return FRCMatch(
      matchID: map['matchID'] as String,
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

  FRCMatch? getMatchByID(String matchKey) {
    for (FRCMatch match in matches) {
      if (match.matchID == matchKey) return match;
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
