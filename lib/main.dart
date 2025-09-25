import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:trigon_scouting_app_2025/authentication/authentication_handler.dart";
import "package:trigon_scouting_app_2025/authentication/user_data_provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/providers/scouted_competition/scouted_competition_provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouters_data_provider.dart";
import "package:trigon_scouting_app_2025/utilities/firebase_handler.dart";
import "package:trigon_scouting_app_2025/utilities/theme.dart";
import "package:trigon_scouting_app_2025/utilities/update_service.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseHandler.initializeFirebase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
        ChangeNotifierProvider(create: (_) => ScoutedCompetitionProvider()),
        ChangeNotifierProvider(create: (_) => ScoutersDataProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateService.checkForUpdate(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: const MaterialTheme(TextTheme()).dark(),
      darkTheme: const MaterialTheme(TextTheme()).darkHighContrast(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const AuthenticationHandler(),
    );
  }
}
