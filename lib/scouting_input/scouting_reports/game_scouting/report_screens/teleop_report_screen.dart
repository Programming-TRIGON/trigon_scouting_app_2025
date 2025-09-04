import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:trigon_scouting_app_2025/utilities/bool_toggle_row.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_report_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/field_elements_scouting_widgets/scoring_elements/scoring_elements_scouting_widget.dart';

class TeleopReportScreen extends StatelessWidget {
  const TeleopReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<GameScoutingReportProvider>();

    return ScoringElementsScoutingWidget(
      forAuto: false,
      boolToggleRow: BoolToggleRow(
        label: 'Did defend?',
        getter: () => reportProvider.report.teleopReport.didDefend,
        setter: (value) => reportProvider.updateTeleop(
          (teleopReport) => teleopReport.didDefend = value,
        ),
        outlineColor: Colors.indigo,
        width: 250,
      ),
    );
  }
}
