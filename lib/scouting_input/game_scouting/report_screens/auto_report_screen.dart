import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_report_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/help_widgets/field_elements_scouting_widgets/scoring_elements/scoring_elements_scouting_widget.dart';

import '../../../utilities/bool_toggle_row.dart';

class AutoReportScreen extends StatelessWidget {
  const AutoReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<GameScoutingReportProvider>();

    return ScoringElementsScoutingWidget(
      forAuto: true,
      boolToggleRow: BoolToggleRow(
        text: Text(
          "Auto line?",
          style: Theme.of(
            context,
          ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
        ),
        getter: () => reportProvider.report.autoReport.crossedAutoLine,
        setter: (value) => reportProvider.updateAuto(
          (autoReport) => autoReport.crossedAutoLine = value,
        ),
        outlineColor: Colors.amber,
      ),
    );
  }
}
