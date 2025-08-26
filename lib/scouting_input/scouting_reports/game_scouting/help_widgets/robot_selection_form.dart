import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_report_provider.dart';
import 'package:trigon_scouting_app_2025/utilities/mandatory.dart';
import 'package:trigon_scouting_app_2025/utilities/tba_handler.dart';

import '../../../../authentication/user_data_provider.dart';
import '../../../../utilities/bool_toggle_row.dart';
import '../../../providers/scouted_competition/scouted_competition_provider.dart';

class RobotSelectionForm extends StatefulWidget {
  const RobotSelectionForm({super.key});

  @override
  State<RobotSelectionForm> createState() => _RobotSelectionFormState();
}

class _RobotSelectionFormState extends State<RobotSelectionForm> {
  final matchTypeController = TextEditingController();
  final matchNumberController = TextEditingController();
  final robotNumberController = TextEditingController();

  @override
  void dispose() {
    matchTypeController.dispose();
    matchNumberController.dispose();
    robotNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = context.watch<UserDataProvider>();
    final reportProvider = context.watch<GameScoutingReportProvider>();
    final scoutedCompetitionProvider = context
        .watch<ScoutedCompetitionProvider>();

    return FittedBox(
      fit: BoxFit.contain,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          createMatchSelectionWidget(
            userDataProvider,
            reportProvider,
            scoutedCompetitionProvider,
          ),
          SizedBox(height: 5),
          createRobotSelectionAndViewRow(
            reportProvider,
            scoutedCompetitionProvider,
          ),
          SizedBox(height: 5),
          BoolToggleRow(
            label: "Bet: will this robot win?",
            getter: () => reportProvider.report.pregameReport.bet,
            setter: (value) => reportProvider.updatePregame(
                  (pregameReport) => pregameReport.bet = value,
            ),
            outlineColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget createMatchSelectionWidget(
    UserDataProvider userDataProvider,
    GameScoutingReportProvider reportProvider,
    ScoutedCompetitionProvider scoutedCompetitionProvider,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Mandatory(
          child: DropdownMenu<String>(
            width: 200,
            label: Text('Match Type', style: TextStyle(color: Colors.grey)),
            controller: matchTypeController,
            initialSelection: reportProvider.report.pregameReport.matchType,
            dropdownMenuEntries: buildMatchTypeSelectionOptions(),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            enabled: true,
            enableSearch: true,
            enableFilter: true,
            onSelected: (value) => onMatchTypeSelection(reportProvider, value),
          ),
        ),
        SizedBox(width: 5),
        Mandatory(
          child: DropdownMenu<int>(
            width: 200,
            label: Text('Match Number', style: TextStyle(color: Colors.grey)),
            controller: matchNumberController,
            initialSelection: reportProvider.report.pregameReport.matchNumber,
            dropdownMenuEntries: buildMatchNumberSelectionOptions(
              userDataProvider,
              scoutedCompetitionProvider,
              reportProvider,
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            enabled: true,
            enableSearch: true,
            enableFilter: true,
            onSelected: (value) => onMatchNumberSelection(
              userDataProvider,
              scoutedCompetitionProvider,
              reportProvider,
              value,
            ),
          ),
        ),
      ],
    );
  }

  Widget createRobotSelectionAndViewRow(
    GameScoutingReportProvider reportProvider,
    ScoutedCompetitionProvider scoutedCompetitionProvider,
  ) {
    return Row(
      children: [
        createRobotSelectionColumn(reportProvider, scoutedCompetitionProvider),
        SizedBox(width: 5),
        createRobotPictureWidget(),
      ],
    );
  }

  Widget createRobotSelectionColumn(
    GameScoutingReportProvider reportProvider,
    ScoutedCompetitionProvider scoutedCompetitionProvider,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Mandatory(
          child: DropdownMenu<int?>(
            width: 200,
            label: Text('Robot Number', style: TextStyle(color: Colors.grey)),
            controller: robotNumberController,
            initialSelection: reportProvider.report.pregameReport.robotNumber,
            dropdownMenuEntries: buildRobotSelectionOptions(
              scoutedCompetitionProvider,
              reportProvider,
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            helperText: scoutedCompetitionProvider.getTeamNameFromNumber(
              reportProvider.report.pregameReport.robotNumber,
            ),
            enabled: reportProvider.report.pregameReport.didOverrideSelection,
            enableSearch: true,
            enableFilter: true,
            onSelected: (value) => onRobotNumberSelection(reportProvider, value),
          ),
        ),
        SizedBox(height: 5),
        Text("Override Selection"),
        Switch(
          value: reportProvider.report.pregameReport.didOverrideSelection,
          onChanged: (value) => {
            reportProvider.updatePregame((pregameReport) {
              pregameReport.robotNumber = null;
              pregameReport.didOverrideSelection = value;
              robotNumberController.clear();
            }),
          },
        ),
      ],
    );
  }

  Widget createRobotPictureWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox.square(dimension: 200, child: Placeholder()),
    );
  }

  List<DropdownMenuEntry<String>> buildMatchTypeSelectionOptions() {
    return ["Practice", "Qualification", "Playoffs", "Finals"].map((matchType) {
      return DropdownMenuEntry(value: matchType, label: matchType);
    }).toList();
  }

  void onMatchTypeSelection(
    GameScoutingReportProvider reportProvider,
    String? value,
  ) {
    return reportProvider.updatePregame((pregameReport) {
      pregameReport.matchType = value;
      if (reportProvider.report.pregameReport.didOverrideSelection) return;
      pregameReport.matchNumber = null;
      pregameReport.robotNumber = null;
      matchNumberController.clear();
      robotNumberController.clear();
    });
  }

  List<DropdownMenuEntry<int>> buildMatchNumberSelectionOptions(
    UserDataProvider userDataProvider,
    ScoutedCompetitionProvider scoutedCompetitionProvider,
    GameScoutingReportProvider reportProvider,
  ) {
    if (reportProvider.report.pregameReport.didOverrideSelection) {
      return scoutedCompetitionProvider.scoutedCompetition?.matches
              .where(
                (match) =>
                    match.matchType ==
                    reportProvider.report.pregameReport.matchType,
              )
              .map(
                (match) => DropdownMenuEntry(
                  value: match.matchNumber,
                  label: match.matchNumber.toString(),
                ),
              )
              .toList() ??
          [];
    }

    if (reportProvider.report.pregameReport.matchType == null) {
      return [];
    }

    return scoutedCompetitionProvider
            .getAvailableGameScoutingMatchNumbers(
              userDataProvider.user!.uid,
              reportProvider.report.pregameReport.matchType!,
            )
            ?.map(
              (matchNumber) => DropdownMenuEntry(
                value: matchNumber,
                label: matchNumber.toString(),
              ),
            )
            .toList() ??
        [];
  }

  void onMatchNumberSelection(
    UserDataProvider userDataProvider,
    ScoutedCompetitionProvider scoutedCompetitionProvider,
    GameScoutingReportProvider reportProvider,
    int? value,
  ) {
    reportProvider.updatePregame((pregameReport) {
      pregameReport.matchNumber = value;

      if (reportProvider.report.pregameReport.didOverrideSelection) return;

      final String? matchKey = FRCMatch.toMatchKey(
        reportProvider.report.pregameReport.matchType,
        reportProvider.report.pregameReport.matchNumber?.toString(),
      );
      if (matchKey == null) return;

      pregameReport.robotNumber = scoutedCompetitionProvider
          .getScoutedTeamInGameScoutingMatch(
            userDataProvider.user!.uid,
            matchKey,
          )
          ?.teamID;
      robotNumberController.text = pregameReport.robotNumber.toString();
    });
  }

  List<DropdownMenuEntry<int>> buildRobotSelectionOptions(
    ScoutedCompetitionProvider scoutedCompetitionProvider,
    GameScoutingReportProvider reportProvider,
  ) {
    if (reportProvider.report.pregameReport.didOverrideSelection) {
      return scoutedCompetitionProvider.scoutedCompetition?.teams
              .map(
                (team) => DropdownMenuEntry(
                  value: team.teamID,
                  label: team.teamID.toString(),
                ),
              )
              .toList() ??
          [];
    }

    if (reportProvider.report.pregameReport.robotNumber == null) return [];

    return [
      DropdownMenuEntry(
        value: reportProvider.report.pregameReport.robotNumber!,
        label: reportProvider.report.pregameReport.robotNumber.toString(),
      ),
    ];
  }

  void onRobotNumberSelection(
    GameScoutingReportProvider reportProvider,
    int? value,
  ) {
    return reportProvider.updatePregame(
      (pregameReport) => pregameReport.robotNumber = value,
    );
  }
}
