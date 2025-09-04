import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:trigon_scouting_app_2025/authentication/user_data_provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouters_data_provider.dart";

class MyDataWidget extends StatelessWidget {
  const MyDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userDataProvider = context.watch<UserDataProvider>();
    final ScoutersDataProvider scoutersDataProvider = context.watch<ScoutersDataProvider>();
    final String? unitName = scoutersDataProvider.getUnitOfUser(userDataProvider.user?.uid ?? "")?.name;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[850], // dark panel background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Score
          const Expanded(
            flex: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
          ),
          const Spacer(flex: 1),
          Expanded(
            flex: 20,
            child: Column(
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
          ),
          const Spacer(flex: 1),
          Expanded(
            flex: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  unitName ?? "---",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "פלוגה",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
