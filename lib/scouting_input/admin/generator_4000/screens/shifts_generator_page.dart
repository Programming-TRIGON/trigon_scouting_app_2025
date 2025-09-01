import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/admin/generator_4000/generator_4000_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouted_competition/scouted_competition_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouters_data_provider.dart';

class ShiftsGeneratorPage extends StatefulWidget {
  const ShiftsGeneratorPage({super.key});

  @override
  State<ShiftsGeneratorPage> createState() => _ShiftsGeneratorPageState();
}

class _ShiftsGeneratorPageState extends State<ShiftsGeneratorPage> {
  final TextEditingController competitionKeyController =
      TextEditingController();
  final TextEditingController consecutiveScoutingMatchesController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    consecutiveScoutingMatchesController.text = "6";
  }

  @override
  void dispose() {
    competitionKeyController.dispose();
    consecutiveScoutingMatchesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scoutedCompetitionProvider = context
        .watch<ScoutedCompetitionProvider>();
    final scoutersDataProvider = context.watch<ScoutersDataProvider>();
    final generator4000Provider = context.watch<Generator4000Provider>();
    competitionKeyController.text =
        scoutedCompetitionProvider.scoutedCompetition?.competitionKey ?? "";

    return Column(
      children: [
        TextField(
          controller: competitionKeyController,
          decoration: const InputDecoration(
            labelText: 'Competition Key',
            border: OutlineInputBorder(),
          ),
        ),
        TextField(
          controller: consecutiveScoutingMatchesController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Max Consecutive Scouting Matches',
            border: OutlineInputBorder(),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            try {
              generator4000Provider.generateShifts(
                scoutersDataProvider,
                competitionKeyController.text,
                int.tryParse(consecutiveScoutingMatchesController.text)!,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Shifts generated and saved successfully!',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              return;
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
          },
          child: const Text("חלל אותי!!"),
        ),
      ],
    );
  }
}
