import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/change_count_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/outlined_text.dart';

import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_report_provider.dart';

class ProcessorScoutingWidget extends StatelessWidget {
  static final Image processorImage = Image.asset('assets/processor.png');
  static const double processorImageWidth = 471;
  static const double processorImageHeight = 434;
  static const double buttonWidth = 135;

  final bool forAuto;
  final Color outlineColor;

  const ProcessorScoutingWidget({
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
        fit: BoxFit.fitWidth,
        alignment: AlignmentDirectional.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: outlineColor, width: 5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                processorImage,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 200),
                        FittedBox(
                          child: OutlinedText(
                            text: 'Success',
                            strokeColor: Colors.black,
                            strokeWidth: 20,
                            style: Theme.of(context).textTheme.displayLarge!
                                .copyWith(
                                  color: Colors.green.shade900,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        ChangeCountWidget(
                          color: Colors.green,
                          buttonWidth: buttonWidth,
                          valueSetter: (value, context) {
                            value = max(value, 0);
                            if (forAuto) {
                              reportProvider.updateReport((report) => report.autoReport.processorAlgaeCount = value);
                            } else {
                              reportProvider.updateReport((report) => report.teleopReport.processorAlgaeCount = value);
                            }
                          },
                          valueGetter: () => forAuto
                              ? reportProvider.report.autoReport.processorAlgaeCount
                              : reportProvider.report.teleopReport.processorAlgaeCount,
                        )
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: OutlinedText(
                    text: 'Processor',
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
