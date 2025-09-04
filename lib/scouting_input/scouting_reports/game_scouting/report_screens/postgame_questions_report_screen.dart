import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_page.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/navigation_buttons_widget.dart";
import "package:trigon_scouting_app_2025/utilities/bool_toggle_row.dart";
import "package:trigon_scouting_app_2025/utilities/mandatory.dart";

import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_report_provider.dart";

class PostgameQuestionsReportScreen extends StatelessWidget {
  const PostgameQuestionsReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<GameScoutingReportProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: FittedBox(
                      child: createQuestionsColumn(context, reportProvider),
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  )
                ],
              ),
            ),
            const Align(
              alignment: Alignment.bottomRight,
              child: Column(
                children: [
                  Spacer(flex: 5),
                  Expanded(
                    flex: 1,
                    child: NavigationButtonsWidget(
                      currentPage: GameScoutingPage.questions,
                      width: 100,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column createQuestionsColumn(
    BuildContext context,
    GameScoutingReportProvider reportProvider,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Postgame Questions",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(decoration: TextDecoration.underline),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: 400,
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: "Additional Comments",
            ),
            onChanged: (value) => reportProvider.updatePostgame(
                  (postgameReport) => postgameReport.comments = value,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Mandatory(
          child: BoolToggleRow(
            label: "Did collect algae from ground?",
            getter: () =>
                reportProvider.report.postgameReport.didCollectAlgaeFromGround,
            setter: (value) => reportProvider.updatePostgame(
              (postgameReport) =>
                  postgameReport.didCollectAlgaeFromGround = value,
            ),
            outlineColor: Colors.grey,
            width: 400,
          ),
        ),
        const SizedBox(height: 10),
        BoolToggleRow(
          label: "Did defend?",
          getter: () => reportProvider.report.teleopReport.didDefend,
          setter: (value) => reportProvider.updateTeleop(
            (teleopReport) => teleopReport.didDefend = value,
          ),
          outlineColor: Colors.grey,
          width: 400,
        ),
      ],
    );
  }
}
