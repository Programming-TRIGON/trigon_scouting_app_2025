import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouting_unit.dart';

import '../../../providers/scouters_data/scouters_data_provider.dart';
import '../generator_4000_provider.dart';

class UnitWidget extends StatefulWidget {
  final ScoutingUnit unit;

  UnitWidget({super.key, required this.unit}){
    log("Creating UnitWidget for unit: ${unit.name}");
}

  @override
  State<UnitWidget> createState() => _UnitWidgetState();
}

class _UnitWidgetState extends State<UnitWidget> {
  @override
  Widget build(BuildContext context) {
    final scoutersDataProvider = context.watch<ScoutersDataProvider>();
    final generator4000Provider = context.watch<Generator4000Provider>();

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: IntrinsicWidth(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red[400]),
                    onPressed: () {
                      log(widget.unit.name.toString());
                      scoutersDataProvider.removeUnitWithoutSending(widget.unit,
                          generator4000Provider.isDay1UnitsSelected);
                    },
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: widget.unit.name,
                      decoration: InputDecoration(
                        labelText: 'Unit name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        widget.unit.name = value;
                        scoutersDataProvider.notifyUpdate();
                      },
                    ),
                  ),
                  Expanded(
                    child: createScoutersDropdownMenu(
                        scoutersDataProvider,
                            (String? newValue) {
                          widget.unit.unitHeadUID = newValue;
                        },
                        "Head Scouter",
                        widget.unit.unitHeadUID
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: createScoutersDropdownMenu(
                        scoutersDataProvider,
                            (String? newValue) {
                          widget.unit.scouter1UID = newValue;
                        },
                        "Scouter 1",
                        widget.unit.scouter1UID
                    ),
                  ),
                  Expanded(
                    child: createScoutersDropdownMenu(
                        scoutersDataProvider,
                            (String? newValue) {
                          widget.unit.scouter2UID = newValue;
                        },
                        "Scouter 2",
                        widget.unit.scouter2UID
                    ),
                  ),
                  Expanded(
                    child: createScoutersDropdownMenu(
                        scoutersDataProvider,
                            (String? newValue) {
                          widget.unit.scouter3UID = newValue;
                        },
                        "Scouter 3",
                        widget.unit.scouter3UID
                    ),
                  )
                ],
              ),
            ],
          ),
        )
    );
  }

  Widget createScoutersDropdownMenu(ScoutersDataProvider scoutersDataProvider,
      Function(String? newValue) onSelected,
      String hintText,
      String? initialValue) {
    return DropdownMenu<String>(
      label: Text(hintText),
      initialSelection: initialValue,
      dropdownMenuEntries: scoutersDataProvider.scouters
          ?.map((scouter) =>
          DropdownMenuEntry<String>(
            value: scouter.uid,
            label: scouter.name,
          ))
          .toList() ?? [],
      onSelected: (String? newValue) {
        onSelected(newValue);
        scoutersDataProvider.notifyUpdate();
      },
    );
  }
}
