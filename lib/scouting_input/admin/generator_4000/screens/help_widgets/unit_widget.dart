import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouter.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouters_data_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouting_unit.dart';

class ScoutingUnitWidget extends StatelessWidget {
  final ScoutingUnit unit;
  final bool isDay1Unit;

  ScoutingUnitWidget({required this.unit, required this.isDay1Unit}) : super(key: ValueKey("${unit.name}day${isDay1Unit ? 1 : 2}"));

  @override
  Widget build(BuildContext context) {
    final scoutersDataProvider = context.watch<ScoutersDataProvider>();
    return FittedBox(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(Icons.delete, color: Colors.red, size: 40),
              tooltip: "Remove Unit",
              onPressed: () {
                scoutersDataProvider.removeUnitWithoutSending(unit, isDay1Unit);
              },
            )
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildScouterDropdown(scoutersDataProvider, "Head Scouter", scoutersDataProvider.getScouterByUid(unit.unitHeadUID), (scouter) {
                unit.unitHeadUID = scouter?.uid;
                scoutersDataProvider.notifyUpdate(doesUpdateUnits: true);
              }),
              SizedBox(height: 20),
              buildScouterDropdown(scoutersDataProvider, "Scouter 1", scoutersDataProvider.getScouterByUid(unit.scouter1UID), (scouter) {
                unit.scouter1UID = scouter?.uid;
                scoutersDataProvider.notifyUpdate(doesUpdateUnits: true);
              }),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start  ,
                children: [
                  buildScouterDropdown(scoutersDataProvider, "Scouter 2", scoutersDataProvider.getScouterByUid(unit.scouter2UID), (scouter) {
                    unit.scouter2UID = scouter?.uid;
                    scoutersDataProvider.notifyUpdate(doesUpdateUnits: true);
                  }),
                  SizedBox(width: 20),
                  buildScouterDropdown(scoutersDataProvider, "Scouter 3", scoutersDataProvider.getScouterByUid(unit.scouter3UID), (scouter) {
                    unit.scouter3UID = scouter?.uid;
                    scoutersDataProvider.notifyUpdate(doesUpdateUnits: true);
                  }),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildScouterDropdown(ScoutersDataProvider scoutersDataProvider, String label, Scouter? initialScouter, Function(Scouter?) onChanged) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(size: 100, Icons.person),
        SizedBox(height: 5),
        DropdownMenu<Scouter>(
          label: Text(label),
          initialSelection: initialScouter,
          width: 200,
          menuHeight: 300,
          enableFilter: true,
          dropdownMenuEntries: scoutersDataProvider.scouters?.map((scouter) => DropdownMenuEntry(value: scouter, label: scouter.name)).toList() ?? [],
          onSelected: onChanged,
        ),
      ],
    );
  }
}
