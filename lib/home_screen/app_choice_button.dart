import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trigon_scouting_app_2025/utilities/material_design_factory.dart';

class AppChoiceButton extends StatelessWidget {
  final String buttonName;
  final String imagePath;
  final Widget targetScreen;

  const AppChoiceButton({
    super.key,
    required this.buttonName,
    required this.imagePath,
    required this.targetScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          buttonName,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        onPressed: () {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
          Navigator.push(
            context,
            MaterialDesignFactory.createModernRoute(targetScreen),
          ).then((v) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]);
          });
        },
      ),
    );
  }
}
