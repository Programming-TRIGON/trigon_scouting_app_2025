import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouters_data_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouting_unit.dart';

class AddUnitFAB extends StatelessWidget {
  final bool isDay1Unit;

  const AddUnitFAB({super.key, required this.isDay1Unit});

  @override
  Widget build(BuildContext context) {
    final scoutersDataProvider = context.watch<ScoutersDataProvider>();

    return FloatingActionButton(
      key: ValueKey('addUnitFAB_day${isDay1Unit ? 1 : 2}'),
      heroTag: 'addUnitFAB_day${isDay1Unit ? 1 : 2}',
      onPressed: () => showAddUnitDialog(context, scoutersDataProvider),
      shape: const CircleBorder(),
      tooltip: 'Add Unit',
      child: const Icon(Icons.add),
    );
  }

  void showAddUnitDialog(BuildContext context, ScoutersDataProvider scoutersDataProvider) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Unit Name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Unit Name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final String unitName = controller.text;
              if (unitName.isNotEmpty) {
                Navigator.of(context).pop();
                addUnit(unitName, context, scoutersDataProvider);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void addUnit(String unitName, BuildContext context, ScoutersDataProvider scoutersDataProvider) {
    final List<ScoutingUnit> units = isDay1Unit
        ? (scoutersDataProvider.day1Units ??= [])
        : (scoutersDataProvider.day2Units ??= []);
    units.any((unit) => unit.name == unitName)
        ? ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unit "$unitName" already exists!')),
          )
        : scoutersDataProvider.addEmptyUnitWithoutSending(isDay1Unit, unitName);
  }
}
