import "package:trigon_scouting_app_2025/scouting_input/providers/scouted_competition/scouted_competition.dart";
import "package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouter.dart";
import "package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouters_data_provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouting_unit.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_shift.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/picture_scouting/picture_scouting_shift.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/super_scouting/super_scouting_shift.dart";
import "package:trigon_scouting_app_2025/utilities/tba_handler.dart";

class ShiftsGeneratorCalculations {
  static AllScoutingShifts generateShiftsSchedule(
    ScoutedCompetition competition,
    ScoutersDataProvider scoutersDataProvider,
    int consecutiveScoutingMatches,
  ) {
    final day1Matches = competition.matches
        .where(
          (match) => match.time?.day == competition.matches.first.time?.day,
        )
        .toList();
    final day2Matches = competition.matches
        .where(
          (match) => match.time?.day != competition.matches.first.time?.day,
        )
        .toList();
    final day1Units = scoutersDataProvider.day1Units!;
    final day2Units = scoutersDataProvider.day2Units!;

    final day1Shifts = generateShiftsForDay(
      day1Units,
      day1Matches,
      consecutiveScoutingMatches,
    );
    final day2Shifts = generateShiftsForDay(
      day2Units,
      day2Matches,
      consecutiveScoutingMatches,
    );
    final pictureScoutingShifts = generatePictureScoutingShifts(
      competition,
      scoutersDataProvider,
    );
    return AllScoutingShifts(
      gameScoutingShifts: addMaps(day1Shifts.key, day2Shifts.key),
      superScoutingShifts: addMaps(day1Shifts.value, day2Shifts.value),
      pictureScoutingShifts: pictureScoutingShifts,
    );
  }

  static Map<String, List<T>> addMaps<T>(
    Map<String, List<T>> map1,
    Map<String, List<T>> map2,
  ) {
    final result = <String, List<T>>{};
    for (final key in {...map1.keys, ...map2.keys}) {
      result[key] = [...(map1[key] ?? []), ...(map2[key] ?? [])];
    }
    return result;
  }

  static Map<String, List<PictureScoutingShift>> generatePictureScoutingShifts(
    ScoutedCompetition competition,
    ScoutersDataProvider scoutersDataProvider,
  ) {
    final List<Scouter> pictureScouters =
        scoutersDataProvider.scouters
            ?.where((scouter) => scouter.isPictureScouter)
            .toList() ??
        [];
    final uidToPictureScoutingShifts =
        generateEmptyUIDToPictureScoutingShiftsMap(pictureScouters);
    if (pictureScouters.isEmpty) {
      return uidToPictureScoutingShifts;
    }
    for (int i = 0; i < competition.teams.length; i++) {
      final team = competition.teams[i];
      final scouter = pictureScouters[i % pictureScouters.length];
      uidToPictureScoutingShifts[scouter.uid]?.add(
        PictureScoutingShift(scoutedTeam: team, didScout: false),
      );
    }
    return uidToPictureScoutingShifts;
  }

  static MapEntry<
    Map<String, List<GameScoutingShift>>,
    Map<String, List<SuperScoutingShift>>
  >
  generateShiftsForDay(
    List<ScoutingUnit> units,
    List<FRCMatch> matches,
    int consecutiveScoutingMatches,
  ) {
    final uidToGameScoutingShifts = generateEmptyUIDToGameScoutingShiftsMap(
      units,
    );
    final uidToSuperScoutingShifts = generateEmptyUIDToSuperScoutingShiftsMap(
      units,
    );
    final amountOfUnits = units.length;

    for (int i = 0; i < matches.length; i++) {
      int blueUnitIndex;
      int redUnitIndex;
      if (amountOfUnits.isEven) {
        blueUnitIndex =
            ((i / consecutiveScoutingMatches).floor() * 2) % amountOfUnits;
        redUnitIndex = blueUnitIndex + 1;
      } else {
        blueUnitIndex =
            ((i / consecutiveScoutingMatches).floor()) % amountOfUnits;
        redUnitIndex =
            ((((i + (consecutiveScoutingMatches ~/ 2)) /
                        consecutiveScoutingMatches)
                    .floor()) +
                1) %
            amountOfUnits;
      }
      final blueUnit = units[blueUnitIndex];
      final redUnit = units[redUnitIndex];
      final match = matches[i];
      addShiftsFromMatch(
        blueUnit,
        match,
        true,
        uidToGameScoutingShifts,
        uidToSuperScoutingShifts,
      );
      addShiftsFromMatch(
        redUnit,
        match,
        false,
        uidToGameScoutingShifts,
        uidToSuperScoutingShifts,
      );
    }

    return MapEntry(uidToGameScoutingShifts, uidToSuperScoutingShifts);
  }

  static void addShiftsFromMatch(
    ScoutingUnit unit,
    FRCMatch match,
    bool isScoutingBlue,
    Map<String, List<GameScoutingShift>> uidToGameScoutingShifts,
    Map<String, List<SuperScoutingShift>> uidToSuperScoutingShifts,
  ) {
    final List<FRCTeam> scoutedAlliance = isScoutingBlue
        ? match.blueTeams
        : match.redTeams;
    uidToGameScoutingShifts[unit.scouter1UID]?.add(
      GameScoutingShift(
        matchKey: match.matchKey,
        scoutedTeam: scoutedAlliance[0],
        didScout: false,
      ),
    );
    uidToGameScoutingShifts[unit.scouter2UID]?.add(
      GameScoutingShift(
        matchKey: match.matchKey,
        scoutedTeam: scoutedAlliance[1],
        didScout: false,
      ),
    );
    uidToGameScoutingShifts[unit.scouter3UID]?.add(
      GameScoutingShift(
        matchKey: match.matchKey,
        scoutedTeam: scoutedAlliance[2],
        didScout: false,
      ),
    );
    uidToSuperScoutingShifts[unit.unitHeadUID]?.add(
      SuperScoutingShift(
        matchKey: match.matchKey,
        isBlueAlliance: isScoutingBlue,
        scoutedAlliance: scoutedAlliance,
        didScout: false,
      ),
    );
  }

  static Map<String, List<GameScoutingShift>>
  generateEmptyUIDToGameScoutingShiftsMap(List<ScoutingUnit> units) {
    final uidToGameScoutingShifts = <String, List<GameScoutingShift>>{};
    for (final unit in units) {
      if (unit.scouter1UID != null) {
        uidToGameScoutingShifts[unit.scouter1UID!] = [];
      }
      if (unit.scouter2UID != null) {
        uidToGameScoutingShifts[unit.scouter2UID!] = [];
      }
      if (unit.scouter3UID != null) {
        uidToGameScoutingShifts[unit.scouter3UID!] = [];
      }
    }
    return uidToGameScoutingShifts;
  }

  static Map<String, List<SuperScoutingShift>>
  generateEmptyUIDToSuperScoutingShiftsMap(List<ScoutingUnit> units) {
    final uidToSuperScoutingShifts = <String, List<SuperScoutingShift>>{};
    for (final unit in units) {
      if (unit.unitHeadUID != null) {
        uidToSuperScoutingShifts[unit.unitHeadUID!] = [];
      }
    }
    return uidToSuperScoutingShifts;
  }

  static Map<String, List<PictureScoutingShift>>
  generateEmptyUIDToPictureScoutingShiftsMap(List<Scouter> pictureScouters) {
    final uidToPictureScoutingShifts = <String, List<PictureScoutingShift>>{};
    for (final scouter in pictureScouters) {
      uidToPictureScoutingShifts[scouter.uid] = [];
    }
    return uidToPictureScoutingShifts;
  }
}
