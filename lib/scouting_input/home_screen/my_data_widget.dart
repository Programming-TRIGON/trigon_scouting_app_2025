import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/authentication/user_data_provider.dart';

class MyDataWidget extends StatelessWidget {
  const MyDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userDataProvider = context.watch<UserDataProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Left: Score
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "10",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Score",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),

          // Center: Role
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                userDataProvider.role!.capitalizedName(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.limeAccent,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Role",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "669",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "פלוגה",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



