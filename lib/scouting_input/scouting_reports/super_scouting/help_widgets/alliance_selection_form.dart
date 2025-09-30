import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:trigon_scouting_app_2025/authentication/user_data_provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/providers/scouted_competition/scouted_competition_provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/super_scouting/super_scouting_report_provider.dart";
import "package:trigon_scouting_app_2025/utilities/mandatory.dart";
import "package:trigon_scouting_app_2025/utilities/tba_handler.dart";

class AllianceSelectionForm extends StatefulWidget {
  const AllianceSelectionForm({super.key});

  @override
  State<AllianceSelectionForm> createState() => _AllianceSelectionFormState();
}

class _AllianceSelectionFormState extends State<AllianceSelectionForm> {
  final matchTypeController = TextEditingController();
  final matchNumberController = TextEditingController();

  @override
  void dispose() {
    matchTypeController.dispose();
    matchNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = context.watch<UserDataProvider>();
    final reportProvider = context.watch<SuperScoutingReportProvider>();
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
          const SizedBox(height: 10),
          createAllianceSelectionButtons(
            reportProvider,
            scoutedCompetitionProvider,
          ),
          const SizedBox(height: 10),
          createOverrideSelectionWidget(
            reportProvider,
            scoutedCompetitionProvider,
          ),
        ],
      ),
    );
  }

  Widget createMatchSelectionWidget(
    UserDataProvider userDataProvider,
    SuperScoutingReportProvider reportProvider,
    ScoutedCompetitionProvider scoutedCompetitionProvider,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Mandatory(
          child: DropdownMenu<String>(
            width: 200,
            label: const Text(
              "Match Type",
              style: TextStyle(color: Colors.grey),
            ),
            controller: matchTypeController,
            initialSelection: reportProvider.report.matchKeyReport.matchType,
            dropdownMenuEntries: buildMatchTypeSelectionOptions(),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            enabled: true,
            enableSearch: true,
            enableFilter: true,
            onSelected: (value) => onMatchTypeSelection(reportProvider, scoutedCompetitionProvider, value),
          ),
        ),
        const SizedBox(width: 5),
        Mandatory(
          child: DropdownMenu<int>(
            width: 200,
            label: const Text(
              "Match Number",
              style: TextStyle(color: Colors.grey),
            ),
            controller: matchNumberController,
            initialSelection: reportProvider.report.matchKeyReport.matchNumber,
            dropdownMenuEntries: buildMatchNumberSelectionOptions(
              userDataProvider,
              scoutedCompetitionProvider,
              reportProvider,
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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

  Widget createAllianceSelectionButtons(
    SuperScoutingReportProvider reportProvider,
    ScoutedCompetitionProvider scoutedCompetitionProvider,
  ) {
    return ToggleButtons(
      isSelected: [
        reportProvider.isBlueAlliance == true, // Blue
        reportProvider.isBlueAlliance == false, // Red
      ],
      borderRadius: BorderRadius.circular(8),
      renderBorder: false,
      onPressed: reportProvider.didOverrideSelection
          ? (int index) {
              reportProvider.updateAlliance(index == 0, scoutedCompetitionProvider);
            }
          : null,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
            border: Border.all(color: Colors.white38, width: 2),
            color: reportProvider.isBlueAlliance == true
                ? Colors.blue[700]
                : Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: const Text("Blue Alliance"),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
            border: Border.all(color: Colors.white38, width: 2),
            color: reportProvider.isBlueAlliance == false
                ? Colors.red[700]
                : Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: const Text("Red Alliance"),
        ),
      ],
    );
  }

  Widget createOverrideSelectionWidget(
    SuperScoutingReportProvider reportProvider,
    ScoutedCompetitionProvider scoutedCompetitionProvider,
  ) {
    return Column(
      children: [
        const Text("Override Selection"),
        Switch(
          value: reportProvider.didOverrideSelection,
          onChanged: (value) => reportProvider.updateOverrideSelection(value),
        ),
      ],
    );
  }

  List<DropdownMenuEntry<String>> buildMatchTypeSelectionOptions() {
    return ["Practice", "Qualification", "Playoffs", "Finals"].map((matchType) {
      return DropdownMenuEntry(value: matchType, label: matchType);
    }).toList();
  }

  void onMatchTypeSelection(
    SuperScoutingReportProvider reportProvider,
    ScoutedCompetitionProvider scoutedCompetitionProvider,
    String? value,
  ) {
    return reportProvider.updateReport((report) {
      report.matchKeyReport.matchType = value;
      report.matchKeyReport.matchNumber = null;
      reportProvider.updateAlliance(null, scoutedCompetitionProvider);
      matchNumberController.clear();
    });
  }

  List<DropdownMenuEntry<int>> buildMatchNumberSelectionOptions(
    UserDataProvider userDataProvider,
    ScoutedCompetitionProvider scoutedCompetitionProvider,
    SuperScoutingReportProvider reportProvider,
  ) {
    if (reportProvider.didOverrideSelection) {
      return scoutedCompetitionProvider.scoutedCompetition?.matches
              .where(
                (match) =>
                    match.matchType ==
                    reportProvider.report.matchKeyReport.matchType,
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

    if (reportProvider.report.matchKeyReport.matchType == null) {
      return [];
    }

    return scoutedCompetitionProvider
            .getAvailableSuperScoutingMatchNumbers(
              userDataProvider.user!.uid,
              reportProvider.report.matchKeyReport.matchType!,
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
    SuperScoutingReportProvider reportProvider,
    int? value,
  ) {
    reportProvider.updateReport((report) {
      report.matchKeyReport.matchNumber = value;

      final String? matchKey = FRCMatch.toMatchKey(
        reportProvider.report.matchKeyReport.matchType,
        reportProvider.report.matchKeyReport.matchNumber?.toString(),
      );
      if (matchKey == null) return;

      final bool? newAlliance = reportProvider.didOverrideSelection ? reportProvider.isBlueAlliance : scoutedCompetitionProvider.getScoutedAllianceColorInSuperScoutingMatch(
        userDataProvider.user!.uid,
        matchKey,
      );

      reportProvider.updateAlliance(
        newAlliance,
        scoutedCompetitionProvider,
      );
    });
  }
}
