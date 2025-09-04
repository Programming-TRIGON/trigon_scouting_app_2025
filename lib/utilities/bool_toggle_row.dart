import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoolToggleRow extends StatelessWidget {
  final String label;
  final bool? Function() getter;
  final void Function(bool) setter;
  final Color outlineColor;
  final double width;

  const BoolToggleRow({
    super.key,
    required this.label,
    required this.getter,
    required this.setter,
    required this.outlineColor,
    this.width = 350
  });

  @override
  Widget build(BuildContext context) {
    final bool? value = getter();

    return FittedBox(
      child: Container(
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: outlineColor, width: 2),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildToggleButton(
                    context: context,
                    icon: Icons.close,
                    selected: value == false,
                    fillColor: Colors.red,
                    onTap: () => setter(false),
                  ),
                  const SizedBox(width: 5),
                  buildToggleButton(
                    context: context,
                    icon: Icons.check,
                    selected: value == true,
                    fillColor: Colors.green,
                    onTap: () => setter(true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildToggleButton({
    required BuildContext context,
    required IconData icon,
    required bool selected,
    required Color fillColor,
    required void Function() onTap,
  }) {
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(35, 35), // Set explicit size
        maximumSize: const Size(35, 35),
        padding: EdgeInsets.zero, // Remove default padding
        backgroundColor: selected ? fillColor : Colors.transparent,
        side: BorderSide(color: Theme.of(context).textTheme.bodyLarge!.color!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: selected ? 2 : 0, // Add elevation when selected for more "pop"
        // ignore: deprecated_member_use
        shadowColor: selected ? fillColor.withValues(alpha: 0.5) : Colors.transparent,
      ),
      child: Center(
        child: Icon(icon, color: selected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).textTheme.bodyLarge!.color),
      ),
    );
  }
}