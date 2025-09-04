import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouter.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouters_data_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouting_unit.dart';

class ScoutingUnitWidget extends StatefulWidget {
  final ScoutingUnit unit;
  final bool isDay1Unit;

  ScoutingUnitWidget({required this.unit, required this.isDay1Unit})
    : super(key: ValueKey('${unit.name}day${isDay1Unit ? 1 : 2}'));

  @override
  State<ScoutingUnitWidget> createState() => _ScoutingUnitWidgetState();
}

class _ScoutingUnitWidgetState extends State<ScoutingUnitWidget> {
  final TextEditingController headScouterController = TextEditingController();
  final TextEditingController scouter1Controller = TextEditingController();
  final TextEditingController scouter2Controller = TextEditingController();
  final TextEditingController scouter3Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    headScouterController.dispose();
    scouter1Controller.dispose();
    scouter2Controller.dispose();
    scouter3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scoutersDataProvider = context.watch<ScoutersDataProvider>();

    headScouterController.text =
        scoutersDataProvider.getScouterByUid(widget.unit.unitHeadUID)?.name ??
        '';
    scouter1Controller.text =
        scoutersDataProvider.getScouterByUid(widget.unit.scouter1UID)?.name ??
        '';
    scouter2Controller.text =
        scoutersDataProvider.getScouterByUid(widget.unit.scouter2UID)?.name ??
        '';
    scouter3Controller.text =
        scoutersDataProvider.getScouterByUid(widget.unit.scouter3UID)?.name ??
        '';

    final availableScouters = scoutersDataProvider.scouters?.where(
        (scouter) {
          return (!scoutersDataProvider.doesHaveUnit(scouter, widget.isDay1Unit))
              && (widget.isDay1Unit ? scouter.doesComeToDay1 : scouter.doesComeToDay2);
        }).toList() ?? [];

    return FittedBox(
      child: Stack(
        fit: StackFit.loose,
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 40),
                  tooltip: 'Remove Unit',
                  onPressed: () {
                    scoutersDataProvider.removeUnitWithoutSending(
                      widget.unit,
                      widget.isDay1Unit,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.orange, size: 40),
                  tooltip: 'Clear',
                  onPressed: () => clearUnit(scoutersDataProvider),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.format_color_fill,
                    color: Colors.green,
                    size: 40,
                  ),
                  tooltip: 'Auto Fill',
                  onPressed: () =>
                      autoFillUnit(scoutersDataProvider, availableScouters),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildScouterDropdown(
                scoutersDataProvider,
                'Head Scouter',
                headScouterController,
                (scouter) {
                  widget.unit.unitHeadUID = scouter?.uid;
                  scoutersDataProvider.notifyUpdate(doesUpdateUnits: true);
                },
                availableScouters,
              ),
              const SizedBox(height: 20),
              buildScouterDropdown(
                scoutersDataProvider,
                'Scouter 1',
                scouter1Controller,
                (scouter) {
                  widget.unit.scouter1UID = scouter?.uid;
                  scoutersDataProvider.notifyUpdate(doesUpdateUnits: true);
                },
                availableScouters,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildScouterDropdown(
                    scoutersDataProvider,
                    'Scouter 2',
                    scouter2Controller,
                    (scouter) {
                      widget.unit.scouter2UID = scouter?.uid;
                      scoutersDataProvider.notifyUpdate(doesUpdateUnits: true);
                    },
                    availableScouters,
                  ),
                  const SizedBox(width: 20),
                  buildScouterDropdown(
                    scoutersDataProvider,
                    'Scouter 3',
                    scouter3Controller,
                    (scouter) {
                      widget.unit.scouter3UID = scouter?.uid;
                      scoutersDataProvider.notifyUpdate(doesUpdateUnits: true);
                    },
                    availableScouters,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void clearUnit(ScoutersDataProvider scoutersDataProvider) {
    widget.unit.unitHeadUID = null;
    widget.unit.scouter1UID = null;
    widget.unit.scouter2UID = null;
    widget.unit.scouter3UID = null;
    scoutersDataProvider.notifyUpdate(doesUpdateUnits: true);
  }

  void autoFillUnit(
    ScoutersDataProvider scoutersDataProvider,
    List<Scouter> availableScouters,
  ) {
    widget.unit.unitHeadUID = availableScouters
        .where((scouter) => scouter.isSuperScouter)
        .firstOrNull
        ?.uid;
    widget.unit.scouter1UID = availableScouters
        .where(
          (scouter) =>
              scouter.isGameScouter && scouter.uid != widget.unit.unitHeadUID,
        )
        .firstOrNull
        ?.uid;
    widget.unit.scouter2UID = availableScouters
        .where(
          (scouter) =>
              scouter.isGameScouter &&
              scouter.uid != widget.unit.unitHeadUID &&
              scouter.uid != widget.unit.scouter1UID,
        )
        .firstOrNull
        ?.uid;
    widget.unit.scouter3UID = availableScouters
        .where(
          (scouter) =>
              scouter.isGameScouter &&
              scouter.uid != widget.unit.unitHeadUID &&
              scouter.uid != widget.unit.scouter1UID &&
              scouter.uid != widget.unit.scouter2UID,
        )
        .firstOrNull
        ?.uid;
    scoutersDataProvider.notifyUpdate(doesUpdateUnits: true);
  }

  Widget buildScouterDropdown(
    ScoutersDataProvider scoutersDataProvider,
    String label,
    TextEditingController controller,
    Function(Scouter?) onChanged,
    List<Scouter> availableScouters,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(size: 100, Icons.person),
        const SizedBox(height: 5),
        DropdownMenu<Scouter>(
          label: Text(label),
          controller: controller,
          width: 200,
          menuHeight: 300,
          enableFilter: true,
          dropdownMenuEntries: availableScouters
              .map(
                (scouter) =>
                    DropdownMenuEntry(value: scouter, label: scouter.name),
              )
              .toList(),
          onSelected: onChanged,
        ),
      ],
    );
  }
}
