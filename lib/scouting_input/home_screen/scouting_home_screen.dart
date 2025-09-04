import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/authentication/user_data_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/admin/generator_4000/generator_4000_screen.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_report_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/report_screens/game_scouting_report_screen.dart';

import '../../utilities/material_design_factory.dart';
import '../admin/generator_4000/generator_4000_provider.dart';
import 'my_data_widget.dart';
import 'my_shifts_widget.dart';

class ScoutingHomeScreen extends StatelessWidget {
  static ScrollController scrollController = ScrollController();

  const ScoutingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userDataProvider = context.read<UserDataProvider>();

    return Scaffold(
      appBar: MaterialDesignFactory.createAppBar(
        context,
        Colors.green,
        'Scouting Input',
        'Main Menu',
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 0),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: const Column(
                children: [
                  MyDataWidget(),
                  SizedBox(height: 20),
                  Divider(thickness: 2, color: Colors.grey),
                  SizedBox(height: 20),
                  MyShiftsWidget(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        childrenButtonSize: const Size(300, 56),
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 12,
        children: [
          SpeedDialChild(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sports_esports, color: Colors.green),
                SizedBox(width: 10),
                Text('New Game Scouting Report'),
              ],
            ),
            onTap: () {
              navigateToGameScoutingPage(context);
            },
          ),
          SpeedDialChild(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 10),
                Text('New Super Scouting Report'),
              ],
            ),
            onTap: () {
              // TODO: navigate to super scouting page
            },
          ),
          SpeedDialChild(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt, color: Colors.blue),
                SizedBox(width: 10),
                Text('New Picture Scouting Report'),
              ],
            ),
            onTap: () {
              // TODO: navigate to picture scouting page
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Offstage(
        offstage: !userDataProvider.role!.hasScoutingAdminAccess,
        child: BottomAppBar(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _NavButton(
                  icon: Icons.analytics_outlined,
                  label: 'המלשן 3000',
                  onTap: () {
                    // TODO: Navigate to page
                  },
                ),
              ),
              const SizedBox(width: 45),
              Expanded(
                child: _NavButton(
                  icon: Icons.schedule_outlined,
                  label: 'המחלל 4000',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialDesignFactory.createModernRoute(
                        ChangeNotifierProvider(
                          create: (_) => Generator4000Provider(),
                          child: const Generator4000Screen(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToGameScoutingPage(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    Navigator.of(context).pushReplacement(
      MaterialDesignFactory.createModernRoute(
        ChangeNotifierProvider(
          create: (_) => GameScoutingReportProvider(
            context.read<UserDataProvider>().user!.uid,
          ),
          child: const GameScoutingReportScreen(),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber, width: 1.5),
          color: Colors.black87,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.amber),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
