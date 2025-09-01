import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:trigon_scouting_app_2025/scouting_input/admin/generator_4000/screens/scouters_generator_page.dart';
import 'package:trigon_scouting_app_2025/scouting_input/admin/generator_4000/screens/shifts_generator_page.dart';
import 'package:trigon_scouting_app_2025/scouting_input/admin/generator_4000/screens/units_generator_page.dart';
import 'package:trigon_scouting_app_2025/scouting_input/admin/generator_4000/shifts_generator_calculations.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouted_competition/scouted_competition.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouters_data_provider.dart';
import 'package:trigon_scouting_app_2025/utilities/firebase_handler.dart';
import 'package:trigon_scouting_app_2025/utilities/tba_handler.dart';

class Generator4000Provider extends ChangeNotifier {
  final TextEditingController scoutersGeneratorSearchController =
      TextEditingController();
  Generator4000Page currentPage = Generator4000Page.scoutersGenerator;
  bool isDay1UnitsSelected = true;

  void setCurrentPage(Generator4000Page page) {
    currentPage = page;
    notifyListeners();
  }

  void setIsDay1UnitsSelected(bool value) {
    isDay1UnitsSelected = value;
    notifyListeners();
  }

  void updateControllerValue() {
    notifyListeners();
  }

  void generateShifts(
    ScoutersDataProvider scoutersDataProvider,
    String competitionKey,
    int maxConsecutiveMatches,
  ) async {
    final FRCCompetition frcCompetition = await TBAHandler.getCompetition(
      competitionKey,
    );
    final ScoutedCompetition scoutedCompetition = ScoutedCompetition(
      competitionKey: competitionKey,
      teams: frcCompetition.teams,
      matches: frcCompetition.matches,
      allScoutingShifts: AllScoutingShifts(),
      maximumScore: 100,
      minimumScore: 20,
    );
    final AllScoutingShifts allScoutingShifts = ShiftsGeneratorCalculations.generateShiftsSchedule(scoutedCompetition, scoutersDataProvider, maxConsecutiveMatches);
    scoutedCompetition.allScoutingShifts = allScoutingShifts;
    await FirebaseHandler.setScoutedCompetition(scoutedCompetition);
    notifyListeners();
  }

  @override
  void dispose() {
    scoutersGeneratorSearchController.dispose();
    super.dispose();
  }
}

enum Generator4000Page {
  scoutersGenerator(
    title: "מחלל הסקאוטרים",
    icon: Icon(CupertinoIcons.person_2_fill),
  ),
  unitsGenerator(
    title: "מחלל הפלוגות",
    icon: Icon(CupertinoIcons.building_2_fill),
  ),
  shiftsGenerator(title: "מחלל המשמרות", icon: Icon(CupertinoIcons.clock_fill));

  final String title;
  final Icon icon;

  const Generator4000Page({required this.title, required this.icon});

  Widget build() {
    switch (this) {
      case Generator4000Page.scoutersGenerator:
        return ScoutersGeneratorPage();
      case Generator4000Page.unitsGenerator:
        return UnitsGeneratorPage();
      case Generator4000Page.shiftsGenerator:
        return ShiftsGeneratorPage();
    }
  }
}
