import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_report_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/change_count_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/outlined_text.dart';

class NetScoutingWidget extends StatelessWidget {
  static final Image netImage = Image.asset("assets/net.png");
  static const double netImageWidth = 973;
  static const double netImageHeight = 256;
  static const double buttonWidth = 140;

  final bool forAuto;
  final Color outlineColor;

  const NetScoutingWidget({
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
      child: FittedBox(
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: outlineColor, width: 5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                netImage,
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 5),
                          FittedBox(
                            child: OutlinedText(
                              text: "Miss",
                              strokeColor: Colors.black,
                              strokeWidth: 20,
                              style: Theme.of(context).textTheme.displayLarge!
                                  .copyWith(
                                    color: Colors.red.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          ChangeCountWidget.changePlacementsValueWidget(
                            buttonWidth: buttonWidth,
                            placements: forAuto
                                ? reportProvider
                                      .report
                                      .autoReport
                                      .netAlgaePlacements
                                : reportProvider
                                      .report
                                      .teleopReport
                                      .netAlgaePlacements,
                            forSuccess: false,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 5),
                          FittedBox(
                            child: OutlinedText(
                              text: "Success",
                              strokeColor: Colors.black,
                              strokeWidth: 20,
                              style: Theme.of(context).textTheme.displayLarge!
                                  .copyWith(
                                    color: Colors.green.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          ChangeCountWidget.changePlacementsValueWidget(
                            buttonWidth: buttonWidth,
                            placements: forAuto
                                ? reportProvider
                                      .report
                                      .autoReport
                                      .netAlgaePlacements
                                : reportProvider
                                      .report
                                      .teleopReport
                                      .netAlgaePlacements,
                            forSuccess: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: OutlinedText(
                    text: "Net",
                    style: Theme.of(context).textTheme.displayLarge,
                    strokeColor: Colors.black,
                    strokeWidth: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}