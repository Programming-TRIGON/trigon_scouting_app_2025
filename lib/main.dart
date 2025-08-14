import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/authentication/authentication_handler.dart';
import 'package:trigon_scouting_app_2025/authentication/user_data_provider.dart';
import 'package:trigon_scouting_app_2025/utilities/firebase_handler.dart';
import 'package:trigon_scouting_app_2025/utilities/tba_handler.dart';
import 'package:trigon_scouting_app_2025/utilities/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseHandler.initializeFirebase();

  // final comp = await TBAHandler.getCompetition("2025isde2");
  // FirebaseHandler.setScoutedCompetition(comp);

  runApp(
    ChangeNotifierProvider(
      create: (_) => UserDataProvider(),
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
      darkTheme: MaterialTheme(TextTheme()).dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const AuthenticationHandler(),
    );
  }
}
