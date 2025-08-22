import 'package:flutter/material.dart';
import 'package:trigon_scouting_app_2025/data_viewer/viewer_home_screen.dart';
import 'package:trigon_scouting_app_2025/home_screen/app_choice_button.dart';
import 'package:trigon_scouting_app_2025/scouting_input/home_screen/scouting_home_screen.dart';
import 'package:trigon_scouting_app_2025/utilities/material_design_factory.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MaterialDesignFactory.createAppBar(
        context,
        Colors.blue,
        null,
        null,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Choose your desired app:",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 30),
                AppChoiceButton(
                  buttonName: "Scouting Input",
                  imagePath: "assets/data_input.png",
                  targetScreen: ScoutingHomeScreen(),
                ),
                SizedBox(height: 10),
                AppChoiceButton(
                  buttonName: "Viewer",
                  imagePath: "assets/viewer.png",
                  targetScreen: ViewerHomeScreen(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
