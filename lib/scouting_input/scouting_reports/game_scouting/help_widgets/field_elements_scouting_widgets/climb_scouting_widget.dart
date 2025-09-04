import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_report.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_report_provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/outlined_text.dart";
import "package:trigon_scouting_app_2025/utilities/bool_toggle_row.dart";
import "package:trigon_scouting_app_2025/utilities/mandatory.dart";

class ClimbScoutingWidget extends StatelessWidget {
  static final Image climbingPositionsImage = Image.asset(
    "assets/climbing_positions.png",
  );

  const ClimbScoutingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<GameScoutingReportProvider>();

    return Offstage(
      offstage: reportProvider.report.endgameReport.didTryToClimb != true,
      child: FittedBox(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            climbingPositionsImage,
            createPositionedClimbGestureDetector(
              context,
              reportProvider,
              false,
              40,
              110,
              50,
              140,
              "Shallow Cage",
            ),
            createPositionedClimbGestureDetector(
              context,
              reportProvider,
              true,
              267,
              250,
              50,
              140,
              "Deep Cage",
            ),
            Align(
              alignment: Alignment.topCenter,
              child: OutlinedText(
                text: "Select Climb Position:",
                style: Theme.of(context).textTheme.headlineLarge,
                strokeColor: Colors.black,
                strokeWidth: 7,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createPositionedClimbGestureDetector(
    BuildContext context,
    GameScoutingReportProvider reportProvider,
    bool forDeepCage,
    double left,
    double top,
    double width,
    double height,
    String name,
  ) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: GestureDetector(
        onTap: () {
          reportProvider.updateEndgame(
            (endgameReport) => endgameReport.deepCage = forDeepCage,
          );
          HapticFeedback.lightImpact();
          showDialog(
            context: context,
            useRootNavigator: false,
            builder: (_) {
              return ChangeNotifierProvider<GameScoutingReportProvider>.value(
                value: reportProvider,
                child: ClimbSelectionPopupWidget(title: name),
              );
            },
          );
        },
        child: Container(
          color: reportProvider.report.endgameReport.deepCage == forDeepCage
              ? Colors.green
              : Colors.transparent,
        ),
      ),
    );
  }
}

class ClimbSelectionPopupWidget extends StatelessWidget {
  final String title;

  const ClimbSelectionPopupWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<GameScoutingReportProvider>();

    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: Mandatory(
              child: BoolToggleRow(
                label: "Did manage to climb?",
                getter: () =>
                    reportProvider.report.endgameReport.didManageToClimb,
                setter: (value) => reportProvider.updateEndgame(
                  (endgameReport) => endgameReport.didManageToClimb = value,
                ),
                outlineColor: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Offstage(
            offstage:
                reportProvider.report.endgameReport.didManageToClimb != false,
            child: createClimbFailureDropdown(context),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Save"),
        ),
      ],
    );
  }

  Widget createClimbFailureDropdown(BuildContext context) {
    return Mandatory(
      child: DropdownMenu<ClimbFailureReason>(
        expandedInsets: EdgeInsets.zero,
        initialSelection: context
            .read<GameScoutingReportProvider>()
            .report
            .endgameReport
            .climbFailureReason,
        onSelected: (value) {
          context.read<GameScoutingReportProvider>().updateEndgame(
                (endgameReport) => endgameReport.climbFailureReason = value,
          );
        },
        hintText: "Climb failure reason",
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        dropdownMenuEntries: ClimbFailureReason.values
            .map(
              (reason) =>
              DropdownMenuEntry(value: reason, label: reason.toNormalText()),
        )
            .toList(),
      ),
    );
  }
}
