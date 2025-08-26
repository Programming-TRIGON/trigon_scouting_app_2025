import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_page.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_report_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/field_elements_scouting_widgets/climb_scouting_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/navigation_buttons_widget.dart';
import 'package:trigon_scouting_app_2025/utilities/bool_toggle_row.dart';
import 'package:trigon_scouting_app_2025/utilities/mandatory.dart';

class EndgameReportScreen extends StatelessWidget {
  const EndgameReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: createRightQuestionsColumn(context)),
            SizedBox(width: 30),
            Expanded(flex: 1, child: createLeftWidgetsColumn(context)),
          ],
        ),
      ),
    );
  }

  Widget createRightQuestionsColumn(BuildContext context) {
    final reportProvider = context.watch<GameScoutingReportProvider>();

    return FittedBox(
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Mandatory(
              child: BoolToggleRow(
                label: "Did try to climb?",
                getter: () => reportProvider.report.endgameReport.didTryToClimb,
                setter: (value) => reportProvider.updateEndgame(
                  (endgameReport) => endgameReport.didTryToClimb = value,
                ),
                outlineColor: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Offstage(
              offstage:
                  reportProvider.report.endgameReport.didTryToClimb != false,
              child: Mandatory(
                child: BoolToggleRow(
                  label: "Did park?",
                  getter: () => reportProvider.report.endgameReport.didPark,
                  setter: (value) => reportProvider.updateEndgame(
                    (endgameReport) => endgameReport.didPark = value,
                  ),
                  outlineColor: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createLeftWidgetsColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(flex: 5, child: ClimbScoutingWidget()),
        Expanded(
          flex: 1,
          child: NavigationButtonsWidget(
            currentPage: GameScoutingPage.endgame,
            width: 100,
          ),
        ),
      ],
    );
  }
}
