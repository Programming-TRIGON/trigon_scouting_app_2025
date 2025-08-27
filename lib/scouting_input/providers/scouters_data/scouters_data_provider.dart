import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:trigon_scouting_app_2025/authentication/user_data_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouter.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouting_unit.dart';

class ScoutersDataProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late DocumentReference<Map<String, dynamic>> scoutersDoc = firestore
      .collection("scouters_data")
      .doc("scouters");
  late DocumentReference<Map<String, dynamic>> unitsDoc = firestore
      .collection("scouters_data")
      .doc("units");

  List<Scouter>? scouters;
  List<ScoutingUnit>? day1Units;
  List<ScoutingUnit>? day2Units;
  StreamSubscription<DocumentSnapshot>? scoutersSubscriber;
  StreamSubscription<DocumentSnapshot>? unitsSubscriber;

  ScoutersDataProvider() {
    initializeData();
    listenData();
  }

  bool isLoading() {
    return scouters == null || day1Units == null || day2Units == null;
  }

  void removeScouterWithoutSending(Scouter scouter) {
    scouters?.removeWhere((s) => s.uid == scouter.uid);
    notifyListeners();
  }

  void removeUnitWithoutSending(ScoutingUnit unit, bool isDay1) {
    if (isDay1) {
      day1Units?.removeWhere((u) => u.name == unit.name);
    } else {
      day2Units?.removeWhere((u) => u.name == unit.name);
    }
    notifyListeners();
  }

  void addEmptyUnitWithoutSending(bool isDay1) {
    if (isDay1) {
      day1Units ??= [];
      final newUnit = ScoutingUnit(name: (day1Units!.length + 1).toString());
      day1Units!.add(newUnit);
    } else {
      day2Units ??= [];
      final newUnit = ScoutingUnit(name: (day2Units!.length + 1).toString());
      day2Units!.add(newUnit);
    }
    notifyListeners();
  }

  void addUserWithoutSending(TRIGONUser user) {
    final newScouter = Scouter(
      uid: user.uid,
      name: user.name,
      isGameScouter: true,
      isSuperScouter: false,
      isPictureScouter: false,
      doesComeToDay1: true,
      doesComeToDay2: true,
    );
    scouters ??= [];
    scouters!.add(newScouter);
    notifyListeners();
  }

  void updateScouterWithoutSending(
    Function(Scouter) updateFunction,
    String uid,
  ) {
    if (scouters == null) return;
    final index = scouters!.indexWhere((scouter) => scouter.uid == uid);
    if (index == -1) return;
    updateFunction(scouters![index]);
    notifyListeners();
  }

  void notifyUpdate() {
    notifyListeners();
  }

  void updateUnitWithoutSending(
    Function(ScoutingUnit) updateFunction,
    String name,
    bool isDay1,
  ) {
    final unitsList = isDay1 ? day1Units : day2Units;
    if (unitsList == null) return;
    final index = unitsList.indexWhere((unit) => unit.name == name);
    if (index == -1) return;
    updateFunction(unitsList[index]);
    notifyListeners();
  }

  void sendScoutersToFirebase() {
    if (scouters == null) return;
    scoutersDoc.set(Scouter.scoutersListToMap(scouters));
  }

  void sendUnitsToFirebase() {
    unitsDoc.set({
      "day1Units": ScoutingUnit.scoutingUnitsListToMap(day1Units),
      "day2Units": ScoutingUnit.scoutingUnitsListToMap(day2Units),
    });
  }

  void initializeData() async {
    await initializeScouters();
    await initializeUnits();
    notifyListeners();
  }

  Future<void> initializeScouters() async {
    final scoutersSnapshot = await scoutersDoc.get();
    if (!scoutersSnapshot.exists || scoutersSnapshot.data() == null) return;
    scouters = Scouter.scoutersListFromMap(scoutersSnapshot.data()!);
  }

  Future<void> initializeUnits() async {
    final unitsSnapshot = await unitsDoc.get();
    if (!unitsSnapshot.exists || unitsSnapshot.data() == null) return;
    final data = unitsSnapshot.data()!;
    day1Units = ScoutingUnit.scoutingUnitsListFromMap(data["day1Units"]);
    day2Units = ScoutingUnit.scoutingUnitsListFromMap(data["day2Units"]);
  }

  void listenData() {
    scoutersSubscriber = scoutersDoc.snapshots().listen(onScoutersSnapshot);
    unitsSubscriber = unitsDoc.snapshots().listen(onUnitsSnapshot);
    notifyListeners();
  }

  void onScoutersSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc.exists && doc.data() != null) {
      scouters = Scouter.scoutersListFromMap(doc.data()!);
    } else {
      scouters = null;
    }
    notifyListeners();
  }

  void onUnitsSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      day1Units = ScoutingUnit.scoutingUnitsListFromMap(data["day1Units"]);
      day2Units = ScoutingUnit.scoutingUnitsListFromMap(data["day2Units"]);
    } else {
      day1Units = null;
      day2Units = null;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    scoutersSubscriber?.cancel();
    unitsSubscriber?.cancel();
    super.dispose();
  }
}
