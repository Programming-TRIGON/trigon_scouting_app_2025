import "package:flutter/cupertino.dart";
import "package:provider/provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/super_scouting/super_scouting_report_provider.dart";

class RobotSuperScoutingReportScreen extends StatefulWidget {
  final int robotAllianceIndex;

  const RobotSuperScoutingReportScreen({super.key, required this.robotAllianceIndex});

  @override
  State<RobotSuperScoutingReportScreen> createState() => _RobotSuperScoutingReportScreenState();
}

class _RobotSuperScoutingReportScreenState extends State<RobotSuperScoutingReportScreen> {
  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final reportProvider = context.read<SuperScoutingReportProvider>();
    notesController.text = reportProvider.report.robotReports[widget.robotAllianceIndex].notes ?? "";
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<SuperScoutingReportProvider>();

    return Column(
      children: [
        const SizedBox(height: 10),
        createNotesField(reportProvider),
        const SizedBox(height: 20),
        createDidDefendSwitch(reportProvider),
        const SizedBox(height: 20),
        createDefenseRateSlider(reportProvider),
      ],
    );
  }

  Widget createNotesField(SuperScoutingReportProvider reportProvider) {
    return CupertinoTextField(
      controller: notesController,
      maxLines: 6,
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.systemGrey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      placeholder: "Enter notes here...",
      style: const TextStyle(fontSize: 16.0),
      padding: const EdgeInsets.all(12.0),
      onChanged: (_) {
        reportProvider.updateReport((report) => report.robotReports[widget.robotAllianceIndex].notes = notesController.text);
      },
    );
  }

  Widget createDidDefendSwitch(SuperScoutingReportProvider reportProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Did Defend",
          style: TextStyle(fontSize: 16.0),
        ),
        CupertinoSwitch(
          value: reportProvider.report.robotReports[widget.robotAllianceIndex].didDefend,
          onChanged: (bool value) {
              reportProvider.updateReport((report) => report.robotReports[widget.robotAllianceIndex].didDefend = value);
          },
        ),
      ],
    );
  }

  Widget createDefenseRateSlider(SuperScoutingReportProvider reportProvider) {
    return Offstage(
      offstage: !reportProvider.report.robotReports[widget.robotAllianceIndex].didDefend,
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Defense Rate",
              style: TextStyle(fontSize: 16.0),
            ),
            CupertinoSlider(
              value: reportProvider.report.robotReports[widget.robotAllianceIndex].defenceRate.toDouble(),
              min: 1,
              max: 7,
              divisions: 7,
              onChanged: (double value) {
                reportProvider.updateReport((report) => report.robotReports[widget.robotAllianceIndex].defenceRate = value.toInt());
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) => Text((index + 1).toString())),
            ),
          ],
        ),
      ),
    );
  }
}
