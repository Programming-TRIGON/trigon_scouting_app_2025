import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_report_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/field_elements_scouting_widgets/scoring_elements/scoring_elements_scouting_widget.dart';
import 'package:trigon_scouting_app_2025/utilities/mandatory.dart';

import 'package:trigon_scouting_app_2025/utilities/bool_toggle_row.dart';

class AutoReportScreen extends StatelessWidget {
  const AutoReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<GameScoutingReportProvider>();

    return ScoringElementsScoutingWidget(
      forAuto: true,
      boolToggleRow: Mandatory(
        child: BoolToggleRow(
          label: 'Auto line?',
          getter: () => reportProvider.report.autoReport.crossedAutoLine,
          setter: (value) => reportProvider.updateAuto(
            (autoReport) => autoReport.crossedAutoLine = value,
          ),
          outlineColor: Colors.amber,
          width: 250,
        ),
      ),
    );
  }
}
