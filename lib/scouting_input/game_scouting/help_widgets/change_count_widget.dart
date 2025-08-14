import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_report.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_report_provider.dart';

Function(int, BuildContext) createPlacementsValueSetter(
  Placements placements,
  bool forSuccess,
) {
  return (newValue, context) {
    if (forSuccess) {
      placements.successes = max(newValue, 0);
    } else {
      placements.misses = max(newValue, 0);
    }
    context.read<GameScoutingReportProvider>().notifyUpdate();
  };
}

class ChangeCountWidget extends StatelessWidget {
  static const double placementsButtonWidthToHeightRatio = 4 / 5;
  static const double defaultPlacementsButtonBorderRadius = 20;
  static const double defaultPlacementsButtonTextSize = 40;
  static const double defaultPlacementsButtonIconSize = 30;
  static const double defaultPlacementsButtonWidth = 70;

  final MaterialColor color;
  final double buttonWidth;
  final Function(int, BuildContext) valueSetter;
  final int Function() valueGetter;

  const ChangeCountWidget({
    super.key,
    required this.color,
    required this.buttonWidth,
    required this.valueSetter,
    required this.valueGetter,
  });

  ChangeCountWidget.changePlacementsValueWidget({
    super.key,
    required this.buttonWidth,
    required Placements placements,
    required bool forSuccess,
  }) : color = forSuccess ? Colors.green : Colors.red,
       valueSetter = createPlacementsValueSetter(placements, forSuccess),
       valueGetter = (() => forSuccess ? placements.successes : placements.misses);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        createDecreaseCountWidget(context),
        createIncreaseCountWidget(context),
      ],
    );
  }

  Material createIncreaseCountWidget(BuildContext context) {
    return Material(
      color: color.shade900,
      borderRadius: BorderRadius.horizontal(
        right: Radius.circular(
          (defaultPlacementsButtonBorderRadius) /
              (defaultPlacementsButtonWidth / buttonWidth),
        ),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          valueSetter(valueGetter() + 1, context);
        },
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(
            (defaultPlacementsButtonBorderRadius) /
                (defaultPlacementsButtonWidth / buttonWidth),
          ),
        ),
        child: Container(
          width: buttonWidth,
          height: buttonWidth * placementsButtonWidthToHeightRatio,
          alignment: Alignment.center,
          child: FittedBox(
            child: Text(
              valueGetter().toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize:
                    (defaultPlacementsButtonTextSize) /
                    (defaultPlacementsButtonWidth / buttonWidth),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Material createDecreaseCountWidget(BuildContext context) {
    return Material(
      color: color.shade300,
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(
          (defaultPlacementsButtonBorderRadius) /
              (defaultPlacementsButtonWidth / buttonWidth),
        ),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          valueSetter(valueGetter() - 1, context);
        },
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(
            (defaultPlacementsButtonBorderRadius) /
                (defaultPlacementsButtonWidth / buttonWidth),
          ),
        ),
        child: Container(
          width: buttonWidth,
          height: buttonWidth * placementsButtonWidthToHeightRatio,
          alignment: Alignment.center,
          child: FittedBox(
            child: Icon(
              Icons.remove,
              color: Colors.black,
              size:
                  (defaultPlacementsButtonIconSize) /
                  (defaultPlacementsButtonWidth / buttonWidth),
            ),
          ),
        ),
      ),
    );
  }
}
