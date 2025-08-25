import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RobotScoreSpeedometer extends StatelessWidget {
  final double robotScore;
  final double highestScore;
  final double lowestScore;

  const RobotScoreSpeedometer({
    super.key,
    required this.robotScore,
    required this.highestScore,
    required this.lowestScore,
  });

  @override
  Widget build(BuildContext context) {
    final double step = (highestScore - lowestScore) / 5;

    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: lowestScore,
          maximum: highestScore,
          startAngle: 180,
          endAngle: 0,
          interval: step,
          canScaleToFit: true,
          showTicks: true,
          showLabels: false,
          axisLineStyle: const AxisLineStyle(
            thickness: 50, // thickness of the “background” arc
            cornerStyle: CornerStyle.bothCurve,
          ),
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: lowestScore,
              endValue: lowestScore + step,
              color: Colors.red,
              startWidth: 50,
              endWidth: 50,
            ),
            GaugeRange(
              startValue: lowestScore + step,
              endValue: lowestScore + 2 * step,
              color: Colors.deepOrange,
              startWidth: 50,
              endWidth: 50,
            ),
            GaugeRange(
              startValue: lowestScore + 2 * step,
              endValue: lowestScore + 3 * step,
              color: Colors.yellow,
              startWidth: 50,
              endWidth: 50,
            ),
            GaugeRange(
              startValue: lowestScore + 3 * step,
              endValue: lowestScore + 4 * step,
              color: Colors.lightGreen,
              startWidth: 50,
              endWidth: 50,
            ),
            GaugeRange(
              startValue: lowestScore + 4 * step,
              endValue: highestScore,
              color: Colors.green,
              startWidth: 50,
              endWidth: 50,
            ),
          ],
          pointers: <GaugePointer>[
            NeedlePointer(
              value: robotScore,
              enableAnimation: true,
              animationDuration: 3000,
              animationType: AnimationType.easeOutBack,
              needleLength: 0.7,
              needleStartWidth: 0,
              needleEndWidth: 5,
              knobStyle: const KnobStyle(
                sizeUnit: GaugeSizeUnit.logicalPixel,
                knobRadius: 8,
                color: Colors.black,
              ),
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: const Text("Elyouzoom",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              angle: 175,
              positionFactor: 0.85,
            ),
            GaugeAnnotation(
              widget: const Text("Legendog",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              angle: 5,
              positionFactor: 0.85,
            ),
          ],
        ),
      ],
    );
  }
}
