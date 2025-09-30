import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/admin/generator_4000/screens/help_widgets/folder_toggle_row.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/discard_changes_dialog_widget.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/super_scouting/help_widgets/alliance_selection_form.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/super_scouting/help_widgets/discard_and_submit_buttons.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/super_scouting/help_widgets/robot_super_scouting_report_screen.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/super_scouting/super_scouting_report_provider.dart";
import "package:trigon_scouting_app_2025/utilities/material_design_factory.dart";

class SuperScoutingReportScreen extends StatelessWidget {
  const SuperScoutingReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<SuperScoutingReportProvider>();
    reportProvider.report.robotReports;

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          final shouldPop = await const DiscardChangesDialogWidget().showOnScreen(context);
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        },child: buildScreen(context, reportProvider)
    );
  }

  Scaffold buildScreen(BuildContext context, SuperScoutingReportProvider reportProvider) {
    return Scaffold(
    appBar: MaterialDesignFactory.createAppBar(
        context, Colors.green, "Scouting Input", "Super Scouting Report"),
    body: SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                const AllianceSelectionForm(),
                const SizedBox(height: 20),
                FolderToggleRow(
                    tabs: mapRobotReports(reportProvider),
                  folderHeight: 400,
                ),
                const SizedBox(height: 20),
                const DiscardAndSubmitButtons()
              ],
            ),
          ),
        ),
      ),
    )
  );
  }

  Map<String, Widget> mapRobotReports(SuperScoutingReportProvider reportProvider) {
    final robotReports = reportProvider.report.robotReports;
    final Map<String, Widget> tabs = {};

    for (int i = 0; i < robotReports.length; i++) {
      final robotReport = robotReports[i];
      if (robotReport.robotNumber == null) {
        continue;
      }
      tabs[robotReport.robotNumber.toString()] = RobotSuperScoutingReportScreen(robotAllianceIndex: i);
    }

    return tabs;
  }
}
