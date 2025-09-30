import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/super_scouting/super_scouting_report_provider.dart";

class DiscardAndSubmitButtons extends StatelessWidget {
  const DiscardAndSubmitButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<SuperScoutingReportProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Button(text: "Discard", callback: () => reportProvider.discardChanges(context)),
        Button(text: "Submit", callback: () => reportProvider.submit(context)),
      ],
    );
  }
}

class Button extends StatelessWidget {
  final double width;
  final String text;
  final void Function() callback;

  const Button({
    super.key,
    this.width = 100,
    required this.text,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      splashColor: Colors.indigo.withValues(alpha: 0.3),
      highlightColor: Colors.indigo.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: width,
        height: width * 0.5,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.grey,
          border: Border.all(color: Colors.indigo),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: FittedBox(
            child: Text(
              text,
              style: TextStyle(
                fontSize: (7) / (50 / width),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
