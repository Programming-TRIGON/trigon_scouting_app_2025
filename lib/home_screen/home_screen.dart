import "package:flutter/material.dart";
import "package:trigon_scouting_app_2025/data_viewer/viewer_home_screen.dart";
import "package:trigon_scouting_app_2025/home_screen/app_choice_button.dart";
import "package:trigon_scouting_app_2025/scouting_input/home_screen/scouting_home_screen.dart";
import "package:trigon_scouting_app_2025/utilities/material_design_factory.dart";
import "package:trigon_scouting_app_2025/utilities/update_service.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                const SizedBox(height: 30),
                const AppChoiceButton(
                  buttonName: "Scouting Input",
                  imagePath: "assets/data_input.png",
                  targetScreen: ScoutingHomeScreen(),
                ),
                const SizedBox(height: 10),
                const AppChoiceButton(
                  buttonName: "Viewer",
                  imagePath: "assets/viewer.png",
                  targetScreen: ViewerHomeScreen(),
                ),
                FutureBuilder(
                  future: UpdateService.getCurrentVersion(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Text("App Version: ${snapshot.data}");
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                FutureBuilder(
                  future: UpdateService.getLatestVersion(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Text("Latest Version: ${snapshot.data}");
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                FutureBuilder(
                  future: UpdateService.isUpdateAvailable(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Text("Has Update: ${snapshot.data}");
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
