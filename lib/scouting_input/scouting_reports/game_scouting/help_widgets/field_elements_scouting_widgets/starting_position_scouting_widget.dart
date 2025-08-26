import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_report_provider.dart';

class StartingPositionScoutingWidget extends StatelessWidget {
  const StartingPositionScoutingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<GameScoutingReportProvider>();
    
    return Visibility(
      visible: reportProvider.report.pregameReport.showedUp == true,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: FittedBox(
        child: Column(
          children: [
            Text("Select a starting position:", style: Theme.of(context).textTheme.bodyLarge),
            Container(
              width: 390 * 0.8,
              height: 340 * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage("assets/starting_positions_image.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 50,
                children: [
                  createStartingPositionsColumn(false, reportProvider),
                  createStartingPositionsColumn(true, reportProvider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createStartingPositionsColumn(bool isRed, GameScoutingReportProvider reportProvider) {
    return FittedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 40,
        children: [
          createStartingPositionButton(isRed ? 3 : 1, isRed, reportProvider),
          createStartingPositionButton(2, isRed, reportProvider),
          createStartingPositionButton(isRed ? 1 : 3, isRed, reportProvider)
        ],
      ),
    );
  }

  Widget createStartingPositionButton(int index, bool isRed, GameScoutingReportProvider reportProvider) {
    final bool isSelected = reportProvider.report.pregameReport.startingPosition == index;

    final Color baseBorderColor = isRed ? Colors.red : Colors.blue;
    final Color selectedColor = Colors.green;
    final Color textColor = isSelected ? Colors.white : baseBorderColor;

    return InkWell(
      splashColor: isSelected ? Colors.green.withValues(alpha: 0.5) : baseBorderColor.withValues(alpha: 0.3),
      highlightColor: isSelected ? Colors.green.withValues(alpha: 0.2) : baseBorderColor.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        HapticFeedback.lightImpact();
        reportProvider.updatePregame((pregameReport) => pregameReport.startingPosition = index);
      },
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.transparent, // Background color changes on selection
          border: Border.all(
            color: isSelected ? selectedColor : baseBorderColor, // Border color changes on selection
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          index.toString(),
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
