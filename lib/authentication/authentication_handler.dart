import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/authentication/login_screen/login_screen.dart';
import 'package:trigon_scouting_app_2025/authentication/user_data_provider.dart';
import 'package:trigon_scouting_app_2025/home_screen/home_screen.dart';
import 'package:trigon_scouting_app_2025/scouting_input/home_screen/scouting_home_screen.dart';

class AuthenticationHandler extends StatelessWidget {
  const AuthenticationHandler({super.key});

  @override
  Widget build(BuildContext context) {
    final userDataProvider = context.watch<UserDataProvider>();

    if (userDataProvider.isDataLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (userDataProvider.error != null) {
      return Scaffold(body: Center(child: Text('Error: ${userDataProvider.error}')));
    }

    if (userDataProvider.user == null) {
      return const LoginScreen();
    }

    if (userDataProvider.role == null || !userDataProvider.role!.hasViewerAccess) {
      return const ScoutingHomeScreen();
    }

    return const HomeScreen();
  }
}
