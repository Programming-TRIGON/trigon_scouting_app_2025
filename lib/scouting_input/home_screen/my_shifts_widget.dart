import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/authentication/user_data_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/scouting_shift.dart';

import '../providers/scouted_competition/scouted_competition_provider.dart';

class MyShiftsWidget extends StatefulWidget {
  const MyShiftsWidget({super.key});

  @override
  State<MyShiftsWidget> createState() => _MyShiftsWidgetState();
}

class _MyShiftsWidgetState extends State<MyShiftsWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userDataProvider = context.watch<UserDataProvider>();
    final scoutedCompetitionProvider = context
        .watch<ScoutedCompetitionProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "My Shifts",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        createToggleButtons(),
        const SizedBox(height: 16),
        createSchedulePanel(userDataProvider, scoutedCompetitionProvider),
      ],
    );
  }

  ToggleButtons createToggleButtons() {
    return ToggleButtons(
      isSelected: [selectedIndex == 0, selectedIndex == 1, selectedIndex == 2],
      onPressed: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(8),
      selectedColor: Colors.white,
      fillColor: Colors.blue[700],
      color: Colors.white70,
      borderColor: Colors.white38,
      selectedBorderColor: Colors.blue[400]!,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text("Game"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text("Super"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text("Picture"),
        ),
      ],
    );
  }

  Widget createSchedulePanel(
    UserDataProvider userDataProvider,
    ScoutedCompetitionProvider scoutedCompetitionProvider,
  ) {
    final List<ScoutingShift>? selectedShifts = getSelectedShifts(
      userDataProvider,
      scoutedCompetitionProvider,
    );

    if (selectedShifts?.isEmpty ?? true) {
      return Text(
        "No shifts available",
        style: TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
      );
    }
    selectedShifts!;

    final quals = selectedShifts
        .where((s) => s.getMatchType() == "Qualification")
        .toList();
    final playoffs = selectedShifts
        .where((s) => s.getMatchType() == "Playoffs")
        .toList();
    final finals = selectedShifts
        .where((s) => s.getMatchType() == "Finals")
        .toList();
    final notOrdered = selectedShifts
        .where((s) => s.getMatchType() == null)
        .toList();

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 450),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Scrollbar(
          thumbVisibility: true,
          interactive: true,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            children: [
              if (notOrdered.isNotEmpty)
                ...notOrdered.map((s) => s.buildScheduleWidget()),
              if (quals.isNotEmpty)
                buildSection("Qualification Matches", quals),
              if (playoffs.isNotEmpty)
                buildSection("Playoff Matches", playoffs),
              if (finals.isNotEmpty) buildSection("Finals", finals),
            ],
          ),
        ),
      ),
    );
  }

  List<ScoutingShift>? getSelectedShifts(
    UserDataProvider userDataProvider,
    ScoutedCompetitionProvider scoutedCompetitionProvider,
  ) {
    switch (selectedIndex) {
      case 0:
        return scoutedCompetitionProvider
            .scoutedCompetition
            ?.allScoutingShifts.gameScoutingShifts?[userDataProvider.user!.uid];
      case 1:
        return scoutedCompetitionProvider
            .scoutedCompetition
            ?.allScoutingShifts.superScoutingShifts?[userDataProvider.user!.uid];
      case 2:
        return scoutedCompetitionProvider
            .scoutedCompetition
            ?.allScoutingShifts.pictureScoutingShifts?[userDataProvider.user!.uid];
      default:
        return null;
    }
  }

  Widget buildSection(String title, List<ScoutingShift> scoutingShifts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...scoutingShifts.map((s) => s.buildScheduleWidget()),
      ],
    );
  }
}
