import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_page.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_report_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/help_widgets/field_elements_scouting_widgets/starting_position_scouting_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/help_widgets/navigation_buttons_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/help_widgets/robot_selection_form.dart';
import 'package:trigon_scouting_app_2025/utilities/bool_toggle_row.dart';

class PregameReportScreen extends StatelessWidget {
  const PregameReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 6, child: RobotSelectionForm()),
            Expanded(flex: 6, child: createRightSideColumnWidget(context)),
          ],
        ),
      ),
    );
  }

  Widget createRightSideColumnWidget(BuildContext context) {
    final reportProvider = context.watch<GameScoutingReportProvider>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: BoolToggleRow(
                  label: "Did Team Show Up?",
                  getter: () => reportProvider.report.pregameReport.showedUp,
                  setter: (value) => reportProvider.updatePregame(
                    (pregameReport) => pregameReport.showedUp = value,
                  ),
                  outlineColor: Colors.grey,
                ),
              ),
              Expanded(flex: 12, child: StartingPositionScoutingWidget()),
            ],
          ),
        ),
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
}
