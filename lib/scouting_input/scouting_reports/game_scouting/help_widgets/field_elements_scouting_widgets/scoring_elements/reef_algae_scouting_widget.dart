import "dart:math";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_report_provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/change_count_widget.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/outlined_text.dart";

class ReefAlgaeScoutingWidget extends StatelessWidget {
  static final Image reefAlgaeImage = Image.asset("assets/reef_algae.png");
  static const double buttonWidth = 60;

  final bool forAuto;
  final Color outlineColor;

  const ReefAlgaeScoutingWidget({
    super.key,
    required this.forAuto,
    required this.outlineColor,
  });

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<GameScoutingReportProvider>();

    return Offstage(
      offstage:
          forAuto && reportProvider.report.autoReport.crossedAutoLine != true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          alignment: AlignmentDirectional.center,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: outlineColor, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      reefAlgaeImage,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          FittedBox(
                            child: OutlinedText(
                              text: "Removes",
                              strokeColor: Colors.black,
                              strokeWidth: 10,
                              style: Theme.of(context).textTheme.headlineMedium!
                                  .copyWith(
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          ChangeCountWidget(
                            color: Colors.blue,
                            buttonWidth: buttonWidth,
                            valueSetter: (value, context) {
                              value = max(value, 0);
                              if (forAuto) {
                                reportProvider.updateReport((report) => report.autoReport.algaeOutOfReefCount = value);
                              } else {
                                reportProvider.updateReport((report) => report.teleopReport.algaeOutOfReefCount = value);
                              }
                            },
                            valueGetter: () => forAuto
                                ? reportProvider.report.autoReport.algaeOutOfReefCount
                                : reportProvider.report.teleopReport.algaeOutOfReefCount,
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: OutlinedText(
                          text: "Reef Algae",
                          style: Theme.of(context).textTheme.headlineMedium,
                          strokeColor: Colors.black,
                          strokeWidth: 5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
