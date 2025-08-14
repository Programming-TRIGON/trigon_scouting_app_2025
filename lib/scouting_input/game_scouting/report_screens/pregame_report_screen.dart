import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_page.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_report_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/help_widgets/field_elements_scouting_widgets/starting_position_scouting_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/help_widgets/navigation_buttons_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouted_competition_provider.dart';
import 'package:trigon_scouting_app_2025/utilities/bool_toggle_row.dart';

class PregameReportScreen extends StatelessWidget {
  static const List<String> matchIDs = ["match 1", "match 2"];

  // static const List<int> robots = [5990, 11];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  PregameReportScreen({super.key});

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
    final reportProvider = context.watch<GameScoutingReportProvider>();
    final scoutedCompetitionProvider = context
        .watch<ScoutedCompetitionProvider>();

    return FittedBox(
      child: SizedBox(
        width: 400,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              DropdownButtonFormField<String>(
                value: reportProvider.report.pregameReport.matchID,
                decoration: InputDecoration(
                  labelText: 'Match ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                items: scoutedCompetitionProvider.scoutedCompetition!.matches
                    .map((value) {
                      return DropdownMenuItem(
                        value: value.matchID,
                        child: Text(value.matchID),
                      );
                    })
                    .toList(),
                onChanged: (value) => reportProvider.updatePregame(
                  (pregameReport) => pregameReport.matchID = value,
                ),
              ),
              SizedBox(height: 5),
              DropdownButtonFormField<int>(
                value: reportProvider.report.pregameReport.robotNumber,
                decoration: InputDecoration(
                  labelText: 'Robot Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) =>
                    value == null ? "Please select a match ID" : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                items: mapTeams(reportProvider, scoutedCompetitionProvider),
                onChanged: (value) => reportProvider.updatePregame(
                  (pregameReport) => pregameReport.robotNumber = value,
                ),
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
      ),
    );
  }

  List<DropdownMenuItem<int>> mapTeams(
    GameScoutingReportProvider reportProvider,
    ScoutedCompetitionProvider scoutedCompetitionProvider,
  ) {
    final String? matchID = reportProvider.report.pregameReport.matchID;

    if (matchID == null) {
      return scoutedCompetitionProvider.scoutedCompetition!.teams.map((value) {
        return DropdownMenuItem(
          value: value.teamID,
          child: Text(value.teamID.toString()),
        );
      }).toList();
    }

    return scoutedCompetitionProvider.scoutedCompetition!.getMatchByID(matchID)!.blueTeams.map((value) {
      return DropdownMenuItem(
        value: value.teamID,
        child: Text(value.teamID.toString()),
      );
    }).toList();
  }
}
