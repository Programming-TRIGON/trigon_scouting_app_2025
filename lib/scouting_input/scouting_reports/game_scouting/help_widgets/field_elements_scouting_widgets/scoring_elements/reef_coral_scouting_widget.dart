import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_report_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/change_count_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/outlined_text.dart';

class ReefCoralScoutingWidget extends StatelessWidget {
  static final Image reefImage = Image.asset("assets/reef_coral.png");
  static const double l1Padding = 108;
  static const double l1PaddingToL2DifferenceRatio = 100 / 92;
  static const double l2DifferenceToL4DifferenceRatio = 3.5 / 3.1;
  static const double buttonWidth = 80;
  static final double buttonHeight =
      buttonWidth * ChangeCountWidget.placementsButtonWidthToHeightRatio;

  final bool forAuto;
  final Color outlineColor;

  const ReefCoralScoutingWidget({
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
        fit: BoxFit.fitHeight,
        alignment: Alignment.bottomLeft,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: outlineColor, width: 5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    createReefPlacementsColumn(
                      context,
                      reportProvider,
                      false,
                      forAuto,
                    ),
                    SizedBox(width: 20),
                    reefImage,
                    SizedBox(width: 10),
                    createReefPlacementsColumn(
                      context,
                      reportProvider,
                      true,
                      forAuto,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: OutlinedText(
                    text: "Reef Coral",
                    style: Theme.of(context).textTheme.displayMedium,
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

  Widget createReefPlacementsColumn(
    BuildContext context,
    GameScoutingReportProvider reportProvider,
    bool forSuccess,
    bool forAuto,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FittedBox(
          child: OutlinedText(
            text: forSuccess ? "Success" : "Miss",
            strokeColor: Colors.black,
            strokeWidth: 10,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: forSuccess ? Colors.green.shade900 : Colors.red.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        createChangeCoralLevelPlacementsButton(
          reportProvider,
          forAuto,
          forSuccess,
          4,
        ),
        SizedBox(
          height:
              (l1Padding *
                  l1PaddingToL2DifferenceRatio *
                  l2DifferenceToL4DifferenceRatio) -
              buttonHeight,
        ),
        createChangeCoralLevelPlacementsButton(
          reportProvider,
          forAuto,
          forSuccess,
          3,
        ),
        SizedBox(
          height: (l1Padding * l1PaddingToL2DifferenceRatio) - (buttonHeight),
        ),
        createChangeCoralLevelPlacementsButton(
          reportProvider,
          forAuto,
          forSuccess,
          2,
        ),
        SizedBox(
          height: (l1Padding * l1PaddingToL2DifferenceRatio) - (buttonHeight),
        ),
        createChangeCoralLevelPlacementsButton(
          reportProvider,
          forAuto,
          forSuccess,
          1,
        ),
        SizedBox(height: l1Padding - (buttonHeight / 2)),
      ],
    );
  }

  Widget createChangeCoralLevelPlacementsButton(
    GameScoutingReportProvider reportProvider,
    bool forAuto,
    bool forSuccess,
    int level,
  ) {
    return ChangeCountWidget.changePlacementsValueWidget(
      buttonWidth: buttonWidth,
      placements: forAuto
          ? reportProvider.report.autoReport.coralPlacements[level - 1]
          : reportProvider.report.teleopReport.coralPlacements[level - 1],
      forSuccess: forSuccess,
    );
  }
}
