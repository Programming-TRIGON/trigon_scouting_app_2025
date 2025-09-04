import 'package:flutter/cupertino.dart';

import 'package:trigon_scouting_app_2025/utilities/tba_handler.dart';

abstract class ScoutingShift {
  final GlobalKey globalKey = GlobalKey();
  bool didScout;

  ScoutingShift({
    required this.didScout
  });

  String getMatchName() {
    return '${getMatchType()} ${getMatchNumber()}';
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