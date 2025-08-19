import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/authentication/user_data_provider.dart';

class MyDataWidget extends StatelessWidget {
  const MyDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userDataProvider = context.watch<UserDataProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[850], // dark panel background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Score
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "10",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreenAccent,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Score",
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),

          // Role
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                userDataProvider.role!.capitalizedName(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "Role",
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),

          // פלוגה / Unit
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "669",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "פלוגה",
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
