import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/admin/generator_4000/generator_4000_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/admin/generator_4000/screens/help_widgets/add_unit_action_button.dart';
import 'package:trigon_scouting_app_2025/scouting_input/admin/generator_4000/screens/help_widgets/folder_toggle_row.dart';
import 'package:trigon_scouting_app_2025/scouting_input/admin/generator_4000/screens/help_widgets/unit_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/admin/generator_4000/screens/help_widgets/update_changes_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouting_unit.dart';

import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouters_data_provider.dart';

class UnitsGeneratorPage extends StatelessWidget {
  const UnitsGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scoutersDataProvider = context.watch<ScoutersDataProvider>();
    final Generator4000Provider generator4000Provider = context
        .watch<Generator4000Provider>();

    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 700, maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              createDayToggleButtons(generator4000Provider),
              const SizedBox(height: 10),
              createTopRowWidget(scoutersDataProvider, generator4000Provider),
              const SizedBox(height: 10),
              PageTransitionSwitcher(
                duration: const Duration(milliseconds: 300),
                reverse: !generator4000Provider.isDay1UnitsSelected,
                transitionBuilder: (Widget child, Animation<double> primaryAnimation, Animation<double> secondaryAnimation) {
                  return SharedAxisTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                    fillColor: Colors.transparent, // keeps background consistent
                    child: child,
                  );
                },
                child: FolderToggleRow(
                  key: generator4000Provider.isDay1UnitsSelected ? const Key('day1UnitsFolder') : const Key('day2UnitsFolder'),
                  tabs: mapUnits(
                    generator4000Provider.isDay1UnitsSelected
                        ? scoutersDataProvider.day1Units ?? []
                        : scoutersDataProvider.day2Units ?? [],
                    generator4000Provider.isDay1UnitsSelected,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createDayToggleButtons(Generator4000Provider generator4000Provider) {
    return ToggleButtons(
      isSelected: [
        generator4000Provider.isDay1UnitsSelected,
        !generator4000Provider.isDay1UnitsSelected,
      ],
      borderRadius: BorderRadius.circular(8),
      selectedColor: Colors.white,
      fillColor: Colors.blue[700],
      color: Colors.white70,
      borderColor: Colors.white38,
      selectedBorderColor: Colors.blue[400]!,
      onPressed: (int index) {
        generator4000Provider.setIsDay1UnitsSelected(index == 0);
      },
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Day 1'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Day 2'),
        ),
      ],
    );
  }

  Map<String, Widget> mapUnits(List<ScoutingUnit> units, bool isDay1Units) {
    return {
      for (var unit in units)
        unit.name: ScoutingUnitWidget(unit: unit, isDay1Unit: isDay1Units),
    };
  }

  Widget createTopRowWidget(
    ScoutersDataProvider scoutersDataProvider,
    Generator4000Provider generator4000Provider,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AddUnitFAB(isDay1Unit: generator4000Provider.isDay1UnitsSelected),
        const SizedBox(width: 10),
        UpdateChangesWidget(
          keyString: 'update_units_changes',
          onUpdate: () => scoutersDataProvider.sendUnitsToFirebase(),
          onDiscard: () => scoutersDataProvider.discardUnitsChanges(),
          isUpdateAvailable: scoutersDataProvider.doesHaveUnsavedUnitsChanges,
        ),
      ],
    );
  }
}
