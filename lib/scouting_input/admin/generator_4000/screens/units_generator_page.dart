import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/admin/generator_4000/generator_4000_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/admin/generator_4000/screens/unit_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouting_unit.dart';

import '../../../../authentication/user_data_provider.dart';
import '../../../providers/scouters_data/scouters_data_provider.dart';

class UnitsGeneratorPage extends StatelessWidget {
  const UnitsGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userDataProvider = context.watch<UserDataProvider>();
    final scoutersDataProvider = context.watch<ScoutersDataProvider>();
    final Generator4000Provider generator4000Provider = context
        .watch<Generator4000Provider>();

    return Align(
      alignment: Alignment.topCenter,
      child: IntrinsicWidth(
        child: Column(
          children: [
            createDayToggleButtons(generator4000Provider),
            SizedBox(height: 10),
            createTopRowWidget(
              userDataProvider,
              scoutersDataProvider,
              generator4000Provider,
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 300,
              width: 600,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  // shrinkWrap: true,
                  // cacheExtent: 0,
                  children: (generator4000Provider.isDay1UnitsSelected ? scoutersDataProvider.day1Units : scoutersDataProvider.day2Units)
                      ?.map((unit) => UnitWidget(unit: unit))
                      .toList() ?? [Text("No units available")],
                ),
              ),
            ),
          ],
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
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Day 1'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Day 2'),
        ),
      ],
    );
  }

  Widget createTopRowWidget(
    UserDataProvider userDataProvider,
    ScoutersDataProvider scoutersDataProvider,
    Generator4000Provider generator4000Provider,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12), // same as DataTable
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 5,
            child: SearchBar(
              onChanged: (_) => generator4000Provider.updateControllerValue(),
              hintText: "Search Units",
              controller: generator4000Provider.unitsGeneratorSearchController,
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            flex: 1,
            child: createAddUserWidget(
              scoutersDataProvider,
              generator4000Provider,
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            flex: 1,
            child: createUploadingDataWidget(scoutersDataProvider),
          ),
        ],
      ),
    );
  }

  Widget createAddUserWidget(
    ScoutersDataProvider scoutersDataProvider,
    Generator4000Provider generator4000Provider,
  ) {
    return FloatingActionButton(
      onPressed: () {
        scoutersDataProvider.addEmptyUnitWithoutSending(
          generator4000Provider.isDay1UnitsSelected,
        );
      },
      shape: CircleBorder(),
      tooltip: "Add Empty Unit",
      child: const Icon(Icons.add),
    );
  }

  Widget createUploadingDataWidget(ScoutersDataProvider scoutersDataProvider) {
    return FloatingActionButton(
      onPressed: () {
        scoutersDataProvider.sendUnitsToFirebase();
      },
      shape: CircleBorder(),
      tooltip: "Upload Data",
      child: const Icon(Icons.upload),
    );
  }
}
