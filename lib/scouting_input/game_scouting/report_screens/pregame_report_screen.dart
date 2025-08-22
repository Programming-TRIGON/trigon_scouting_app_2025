import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/authentication/user_data_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_page.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_report_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/help_widgets/field_elements_scouting_widgets/starting_position_scouting_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/help_widgets/navigation_buttons_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouted_competition_provider.dart';
import 'package:trigon_scouting_app_2025/utilities/bool_toggle_row.dart';
import 'package:trigon_scouting_app_2025/utilities/tba_handler.dart';

class PregameReportScreen extends StatefulWidget {
  const PregameReportScreen({super.key});

  @override
  State<PregameReportScreen> createState() => _PregameReportScreenState();
}

class _PregameReportScreenState extends State<PregameReportScreen> {
  final TextEditingController matchTypeController = TextEditingController();
  final TextEditingController matchNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: createPregameForm(context)),
            SizedBox(width: 30),
            Expanded(flex: 1, child: createLeftSideColumnWidget(context)),
          ],
        ),
      ),
    );
  }

  Widget createLeftSideColumnWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(flex: 5, child: StartingPositionScoutingWidget()),
        Expanded(
          flex: 1,
          child: NavigationButtonsWidget(
            currentPage: GameScoutingPage.pregame,
            width: 100,
          ),
        ),
      ],
    );
  }

  Widget createPregameForm(BuildContext context) {
    final userDataProvider = context.watch<UserDataProvider>();
    final scoutedCompetitionProvider = context.watch<ScoutedCompetitionProvider>();
    final reportProvider = context.watch<GameScoutingReportProvider>();

    return FittedBox(
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            createMatchSelectionWidget(userDataProvider, scoutedCompetitionProvider, reportProvider),
            SizedBox(height: 5),
            DropdownMenu<String>(
              enabled: false,
              initialSelection: reportProvider.report.pregameReport.robotNumber?.toString() ?? "Please select a valid match",
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Robot Number'),
              ),
              dropdownMenuEntries: [
                DropdownMenuEntry(
                  label: reportProvider.report.pregameReport.robotNumber.toString(),
                  value: reportProvider.report.pregameReport.robotNumber.toString()
                )
              ],
            ),
            SizedBox(height: 5),
            BoolToggleRow(
              text: Text(
                "Showed Up",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              getter: () => reportProvider.report.pregameReport.showedUp,
              setter: (value) => reportProvider.updatePregame(
                (pregameReport) => pregameReport.showedUp = value,
              ),
              outlineColor: Colors.grey,
            ),
            SizedBox(height: 5),
            BoolToggleRow(
              text: Text(
                "Bet: will this robot win?",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              getter: () => reportProvider.report.pregameReport.bet,
              setter: (value) => reportProvider.updatePregame(
                (pregameReport) => pregameReport.bet = value,
              ),
              outlineColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget createMatchSelectionWidget(UserDataProvider userDataProvider, ScoutedCompetitionProvider scoutedCompetitionProvider, GameScoutingReportProvider reportProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DropdownMenu<String>(
          controller: matchTypeController,
          dropdownMenuEntries: [
            DropdownMenuEntry(value: "Practice", label: "Practice"),
            DropdownMenuEntry(value: "Qualification", label: "Qualification"),
            DropdownMenuEntry(value: "Playoffs", label: "Playoffs"),
            DropdownMenuEntry(value: "Finals", label: "Finals")
          ],
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('Match Type'),
          ),
          onSelected: (_) {
            matchNumberController.clear();
            reportProvider.updatePregame((pregameReport) => pregameReport.robotNumber = null);
          }
        ),
        DropdownMenu<int>(
          controller: matchNumberController,
          dropdownMenuEntries: scoutedCompetitionProvider.getAvailableGameScoutingMatchNumbers(userDataProvider.user!.uid, matchTypeController.text)
              ?.map((matchNumber) => DropdownMenuEntry(value: matchNumber, label: matchNumber.toString())).toList() ?? [],
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Match Number'),
            ),
          onSelected: (_) => reportProvider.updatePregame((pregameReport) {
            pregameReport.matchKey = FRCMatch.toMatchKey(matchTypeController.text, matchNumberController.text);
            if (pregameReport.matchKey == null) return;
            pregameReport.robotNumber = scoutedCompetitionProvider.getScoutedTeamInGameScoutingMatch(userDataProvider.user!.uid, pregameReport.matchKey!)?.teamID;
          })
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    matchTypeController.dispose();
    matchNumberController.dispose();
  }
}
