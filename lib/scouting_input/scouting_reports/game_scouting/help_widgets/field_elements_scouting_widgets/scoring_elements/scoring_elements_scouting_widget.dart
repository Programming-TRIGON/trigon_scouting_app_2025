import 'package:flutter/material.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_page.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/field_elements_scouting_widgets/scoring_elements/net_scouting_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/field_elements_scouting_widgets/scoring_elements/processor_scouting_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/field_elements_scouting_widgets/scoring_elements/reef_algae_scouting_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/field_elements_scouting_widgets/scoring_elements/reef_coral_scouting_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/help_widgets/navigation_buttons_widget.dart';

class ScoringElementsScoutingWidget extends StatelessWidget {
  final bool forAuto;
  final Widget boolToggleRow;

  const ScoringElementsScoutingWidget({
    super.key,
    required this.forAuto,
    required this.boolToggleRow,
  });

  @override
  Widget build(BuildContext context) {
    final Color outlineColor = forAuto ? Colors.amber : Colors.indigo;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: ReefCoralScoutingWidget(
                forAuto: forAuto,
                outlineColor: outlineColor,
              ),
            ),
            Expanded(flex: 1, child: createLeftColumn(context, outlineColor)),
          ],
        ),
      ),
    );
  }

  Widget createLeftColumn(BuildContext context, Color outlineColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: NetScoutingWidget(
            forAuto: forAuto,
            outlineColor: outlineColor,
          ),
        ),
        Expanded(flex: 2, child: createBottomLeftRow(context, outlineColor)),
      ],
    );
  }

  Widget createBottomLeftRow(BuildContext context, Color outlineColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: createReefAlgaeAndToggleColumn(context, outlineColor),
        ),
        Expanded(
          flex: 1,
          child: createProcessorAndNavigationColumn(context, outlineColor),
        ),
      ],
    );
  }

  Widget createReefAlgaeAndToggleColumn(
    BuildContext context,
    Color outlineColor,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: ReefAlgaeScoutingWidget(
            forAuto: forAuto,
            outlineColor: outlineColor,
          ),
        ),
        Expanded(flex: 1, child: FittedBox(child: boolToggleRow)),
      ],
    );
  }

  Widget createProcessorAndNavigationColumn(
    BuildContext context,
    Color outlineColor,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: ProcessorScoutingWidget(
            forAuto: forAuto,
            outlineColor: outlineColor,
          ),
        ),
        Expanded(
          flex: 1,
          child: NavigationButtonsWidget(
            currentPage: forAuto
                ? GameScoutingPage.auto
                : GameScoutingPage.teleop,
            width: 100,
          ),
        ),
      ],
    );
  }
}
