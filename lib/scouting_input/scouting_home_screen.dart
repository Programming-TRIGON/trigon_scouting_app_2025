import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/authentication/user_data_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_report_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/report_screens/game_scouting_report_screen.dart';
import 'package:trigon_scouting_app_2025/utilities/material_design_factory.dart';

class ScoutingHomeScreen extends StatelessWidget {
  const ScoutingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<UserDataProvider>();

    return Scaffold(
      appBar: MaterialDesignFactory.createAppBar(
        context,
        Colors.green,
        " - Scouting Input",
        "Main Menu",
      ),
      body: FloatingActionButton(
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialDesignFactory.createModernRoute(
            ChangeNotifierProvider(
              create: (_) => GameScoutingReportProvider(userData.user!.uid),
              child: GameScoutingReportScreen(),
            ),
          ),
        ),
        child: Text("New Game Scouting Report"),
      ),
    );
  }
}
