import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_page.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/help_widgets/navigation_buttons_widget.dart';
import 'package:trigon_scouting_app_2025/utilities/bool_toggle_row.dart';
import 'package:trigon_scouting_app_2025/utilities/mandatory.dart';

import '../game_scouting_report_provider.dart';

class PostgameQuestionsReportScreen extends StatelessWidget {
  const PostgameQuestionsReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<GameScoutingReportProvider>();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Stack(
          children: [
            SizedBox.expand(
              child: FittedBox(
                child: createQuestionsColumn(context, reportProvider),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 300,
                child: FittedBox(
                  child: NavigationButtonsWidget(
                    currentPage: GameScoutingPage.questions,
                    width: 100,
                  ),
                ),
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
        SizedBox(height: 15),
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
          ),
        ),
        SizedBox(height: 10),
        BoolToggleRow(
          label: "Did defend?",
          getter: () => reportProvider.report.teleopReport.didDefend,
          setter: (value) => reportProvider.updateTeleop(
            (teleopReport) => teleopReport.didDefend = value,
          ),
          outlineColor: Colors.grey,
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 350,
          height: 200,
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Additional Comments',
            ),
            onChanged: (value) => reportProvider.updatePostgame(
              (postgameReport) => postgameReport.comments = value,
            ),
          ),
        ),
      ],
    );
  }
}
