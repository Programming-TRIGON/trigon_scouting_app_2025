import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/authentication/authentication_handler.dart';
import 'package:trigon_scouting_app_2025/authentication/user_data_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouted_competition/scouted_competition_provider.dart';
import 'package:trigon_scouting_app_2025/utilities/firebase_handler.dart';
import 'package:trigon_scouting_app_2025/utilities/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseHandler.initializeFirebase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
        ChangeNotifierProvider(create: (_) => ScoutedCompetitionProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MaterialTheme(TextTheme()).dark(),
      darkTheme: MaterialTheme(TextTheme()).darkHighContrast(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const AuthenticationHandler(),
    );
  }
}
