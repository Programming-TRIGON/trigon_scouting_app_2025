import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_page.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/help_widgets/navigation_buttons_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/help_widgets/robot_score_speedometer.dart';

import '../../scouted_competition_provider.dart';
import '../game_scouting_report_provider.dart';

class PostgameReviewReportScreen extends StatelessWidget {
  const PostgameReviewReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.read<GameScoutingReportProvider>();
    final scoutedCompetitionProvider = context.read<ScoutedCompetitionProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: createVisualTextBox(
                    context,
                    Text(
                      "Match Data Review",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(decoration: TextDecoration.underline),
                    ),
                    Text(
                      reportProvider.report.pregameReport.robotNumber!.toString(),
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(color: Colors.green),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(flex: 1),
                      Expanded(
                        flex: 2,
                        child: createVisualTextBox(
                          context,
                          Text(
                            "Cycles In Game",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Text(
                            reportProvider.report.calculateCycles().toString(),
                            style: Theme.of(
                              context,
                            ).textTheme.displayLarge?.copyWith(color: Colors.red),
                          ),
                        ),
                      ),
                      Spacer(flex: 2),
                      Expanded(
                        flex: 2,
                        child: createVisualTextBox(
                          context,
                          Text(
                            "Points In Game",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Text(
                            reportProvider.report.calculateTotalPoint().toString(),
                            style: Theme.of(
                              context,
                            ).textTheme.displayLarge?.copyWith(color: Colors.orange),
                          ),
                        ),
                      ),
                      Spacer(flex: 1),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: FittedBox(
                    child: RobotScoreSpeedometer(
                      robotScore: reportProvider.report.calculateTotalPoint().toDouble(),
                      highestScore: scoutedCompetitionProvider.scoutedCompetition!.maximumScore,
                      lowestScore: scoutedCompetitionProvider.scoutedCompetition!.minimumScore,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                children: [
                  Spacer(flex: 5),
                  Expanded(
                    flex: 1,
                    child: NavigationButtonsWidget(
                      currentPage: GameScoutingPage.review,
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

  Widget createVisualTextBox(BuildContext context, Text label, Text innerText) {
    return FittedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          label,
          Container(
            width: 180,
            height: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 4, color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            child: innerText,
          ),
        ],
      ),
    );
  }
}
