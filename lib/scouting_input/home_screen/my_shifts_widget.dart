import 'package:flutter/material.dart';

class MyShiftsWidget extends StatefulWidget {
  const MyShiftsWidget({super.key});

  @override
  State<MyShiftsWidget> createState() => _MyShiftsWidgetState();
}

class _MyShiftsWidgetState extends State<MyShiftsWidget> {
  final List<String> gameScoutingShifts = [
    // Practice
    "Practice 1, 1690: Orbit",
    "Practice 2, 2056: Steel Raptors",
    "Practice 3, 987: Titanium Tigers",

    // Qualification Matches
    "Qualification 1, 1114: Simbotics",
    "Qualification 2, 254: Cheesy Poofs",
    "Qualification 3, 1678: Citrus Circuits",
    "Qualification 4, 33: Killer Bees",
    "Qualification 5, 148: Robowranglers",
    "Qualification 6, 4334: Night Hawks",
    "Qualification 7, 624: Big Bang",
    "Qualification 8, 118: Robonauts",
    "Qualification 9, 604: Quixilver",
    "Qualification 10, 2053: NRG",
    "Qualification 11, 4003: Triple Helix",
    "Qualification 12, 207: Thunder Chicks",
    "Qualification 13, 195: CyberKnights",
    "Qualification 14, 75: RoboRaiders",
    "Qualification 15, 1671: Citrus Circuits",
    "Qualification 16, 1640: Sab-BOT-age",
    "Qualification 17, 33: Killer Bees",
    "Qualification 18, 604: Quixilver",
    "Qualification 19, 254: Cheesy Poofs",
    "Qualification 20, 987: Titanium Tigers",
    "Qualification 21, 2056: OP Robotics",
    "Qualification 22, 1690: Orbit",

    // Finals
    "Finals SF1, 5990: Quantum Crushers",
    "Finals SF2, 1114: Simbotics",
    "Finals SF3, 1678: Citrus Circuits",
    "Finals F1, 254: Cheesy Poofs",
    "Finals F2, 2056: OP Robotics",
  ];
  final List<String> superScoutingShifts = [
    "Finals SF1, 5990: Quantum Crushers",
    "Finals SF2, 1114: Simbotics",
    "Finals SF3, 1678: Citrus Circuits",
  ];
  final List<String> picScoutingShifts = [];

  int selectedIndex = 0;

  List<String> get selectedShifts {
    switch (selectedIndex) {
      case 0:
        return gameScoutingShifts;
      case 1:
        return superScoutingShifts;
      case 2:
        return picScoutingShifts;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "My Shifts",
            style: Theme
                .of(context)
                .textTheme
                .headlineSmall!
                .copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          createToggleButtons(),
          const SizedBox(height: 16),
          createShiftsListView()
        ],
      ),
    );
  }

  ToggleButtons createToggleButtons() {
    return ToggleButtons(
        isSelected: [
          selectedIndex == 0,
          selectedIndex == 1,
          selectedIndex == 2,
        ],
        onPressed: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(8),
        selectedColor: Colors.white,
        fillColor: Colors.green[700],
        color: Colors.white70,
        borderColor: Colors.white38,
        selectedBorderColor: Colors.green[400]!,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("Game"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("Super"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("Pic"),
          ),
        ],
      );
  }

  Widget createShiftsListView() {
    if (selectedShifts.isEmpty) {
      return Text(
        "No shifts available",
        style: TextStyle(
          color: Colors.grey[400],
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: selectedShifts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[700]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[850],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Center(
                  child: Text(
                    selectedShifts[index],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
