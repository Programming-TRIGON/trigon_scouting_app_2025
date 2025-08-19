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
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          createToggleButtons(),
          const SizedBox(height: 16),
          createSchedulePanel(),
        ],
      ),
    );
  }

  ToggleButtons createToggleButtons() {
    return ToggleButtons(
      isSelected: [selectedIndex == 0, selectedIndex == 1, selectedIndex == 2],
      onPressed: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(8),
      selectedColor: Colors.white,
      fillColor: Colors.blue[700],
      color: Colors.white70,
      borderColor: Colors.white38,
      selectedBorderColor: Colors.blue[400]!,
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
          child: Text("Picture"),
        ),
      ],
    );
  }

  Widget createSchedulePanel() {
    if (selectedShifts.isEmpty) {
      return Text(
        "No shifts available",
        style: TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
      );
    }

    final practice = selectedShifts.where((s) => s.startsWith("Practice")).toList();
    final quals = selectedShifts.where((s) => s.startsWith("Qualification")).toList();
    final finals = selectedShifts.where((s) => s.startsWith("Finals")).toList();

    return Flexible(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Scrollbar(
          thumbVisibility: true,
          interactive: true,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            children: [
              if (practice.isNotEmpty) buildSection("Practice", practice),
              if (quals.isNotEmpty) buildSection("Qualification Matches", quals),
              if (finals.isNotEmpty) buildSection("Finals", finals),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items.map(
              (s) => Card(
            color: Colors.grey[850],
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.schedule, color: Colors.blue[400]),
              title: Text(s, style: const TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }
}
