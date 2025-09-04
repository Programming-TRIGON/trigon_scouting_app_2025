import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/authentication/login_screen/login_screen.dart';
import 'package:trigon_scouting_app_2025/authentication/user_data_provider.dart';
import 'package:trigon_scouting_app_2025/home_screen/home_screen.dart';
import 'package:trigon_scouting_app_2025/scouting_input/home_screen/scouting_home_screen.dart';
import 'package:trigon_scouting_app_2025/utilities/material_design_factory.dart';

class AuthenticationHandler extends StatelessWidget {
  const AuthenticationHandler({super.key});

  @override
  Widget build(BuildContext context) {
    final userDataProvider = context.watch<UserDataProvider>();

    if (userDataProvider.isDataLoading) {
      return MaterialDesignFactory.createLoadingPage('User Data Loading...');
    }

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    if (userDataProvider.user == null) {
      return const LoginScreen();
    }

    if (userDataProvider.role == null || !userDataProvider.role!.hasViewerAccess) {
      return const ScoutingHomeScreen();
    }

    return const HomeScreen();
  }
}
