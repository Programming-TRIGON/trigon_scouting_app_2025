import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/authentication/user_data_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/game_scouting_report_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/game_scouting/report_screens/game_scouting_report_screen.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouted_competition_provider.dart';
import 'package:trigon_scouting_app_2025/utilities/material_design_factory.dart';

class ScoutingHomeScreen extends StatelessWidget {
  const ScoutingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<UserDataProvider>();
    final scoutedCompetitionProvider = context
        .watch<ScoutedCompetitionProvider>();

    return Scaffold(
      appBar: MaterialDesignFactory.createAppBar(
        context,
        Colors.green,
        " - Scouting Input",
        "Main Menu",
      ),
      body: FloatingActionButton(
        onPressed: () {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
          Navigator.push(
            context,
            MaterialDesignFactory.createModernRoute(
              MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (_) =>
                        GameScoutingReportProvider(userData.user!.uid),
                  ),
                  ChangeNotifierProvider.value(
                    value: scoutedCompetitionProvider,
                  ),
                ],
                child: GameScoutingReportScreen(),
              ),
            ),
          ).then((_) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]);
          });
        },
        child: Text("New Game Scouting Report"),
      ),
    );
  }
}
