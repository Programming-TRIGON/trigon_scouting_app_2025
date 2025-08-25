import 'package:flutter/cupertino.dart';

import '../utilities/tba_handler.dart';

abstract class ScoutingShift {
  bool didScout;

  ScoutingShift({
    required this.didScout
  });

  String getMatchName() {
    return "${getMatchType()} ${getMatchKey()}";
  }

  String? getMatchType() {
    return FRCMatch.toMatchType(getMatchKey());
  }

  int getMatchNumber() {
    return FRCMatch.toMatchNumber(getMatchKey());
  }

  String? getMatchKey() {
    return null;
  }

  Widget buildScheduleWidget();

  Map<String, dynamic> toMap();
}