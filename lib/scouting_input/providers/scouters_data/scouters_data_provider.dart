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

  bool doesHaveUnsavedScoutersChanges = false;
  bool doesHaveUnsavedUnitsChanges = false;

  ScoutersDataProvider() {
    initializeData();
    listenData();
  }

  bool isLoading() {
    return scouters == null || day1Units == null || day2Units == null;
  }

  Scouter? getScouterByUid(String? uid) {
    if (scouters == null || uid == null) return null;
    return scouters!.where((scouter) => scouter.uid == uid).firstOrNull;
  }

  bool doesHaveUnit(Scouter scouter, bool isDay1) {
    if (day1Units == null || day2Units == null) return false;
    final unitsList = isDay1 ? day1Units : day2Units;
    return unitsList!.any(
      (unit) => unit.getScoutersUIDs().contains(scouter.uid),
    );
  }

  ScoutingUnit? getUnitOfUser(String uid) {
    if (day1Units == null || day2Units == null) return null;
    final unit = day1Units!
        .where((unit) => unit.getScoutersUIDs().contains(uid))
        .firstOrNull;
    if (unit != null) return unit;
    return day2Units!
        .where((unit) => unit.getScoutersUIDs().contains(uid))
        .firstOrNull;
  }

  void removeScouterWithoutSending(Scouter scouter) {
    scouters?.removeWhere((s) => s.uid == scouter.uid);
    doesHaveUnsavedScoutersChanges = true;
    notifyListeners();
  }

  void removeUnitWithoutSending(ScoutingUnit unit, bool isDay1) {
    if (isDay1) {
      day1Units?.removeWhere((u) => u.name == unit.name);
    } else {
      day2Units?.removeWhere((u) => u.name == unit.name);
    }
    doesHaveUnsavedUnitsChanges = true;
    notifyListeners();
  }

  void addEmptyUnitWithoutSending(bool isDay1, String unitName) {
    final newUnit = ScoutingUnit(name: unitName);
    if (isDay1) {
      day1Units ??= [];
      day1Units!.add(newUnit);
    } else {
      day2Units ??= [];
      day2Units!.add(newUnit);
    }
    doesHaveUnsavedUnitsChanges = true;
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
    doesHaveUnsavedScoutersChanges = true;
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
    doesHaveUnsavedScoutersChanges = true;
    notifyListeners();
  }

  void notifyUpdate({bool? doesUpdateScouters, bool? doesUpdateUnits}) {
    notifyListeners();
    if (doesUpdateScouters == true) {
      doesHaveUnsavedScoutersChanges = true;
    }
    if (doesUpdateUnits == true) {
      doesHaveUnsavedUnitsChanges = true;
    }
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
    doesHaveUnsavedUnitsChanges = true;
    notifyListeners();
  }

  void sendScoutersToFirebase() async {
    if (scouters == null) return;
    await scoutersDoc.set({'scouters': Scouter.scoutersListToMap(scouters)});
    doesHaveUnsavedScoutersChanges = false;
    notifyListeners();
  }

  void sendUnitsToFirebase() async {
    await unitsDoc.set({
      "day1Units": ScoutingUnit.scoutingUnitsListToMap(day1Units),
      "day2Units": ScoutingUnit.scoutingUnitsListToMap(day2Units),
    });
    doesHaveUnsavedUnitsChanges = false;
    notifyListeners();
  }

  void discardScoutersChanges() async {
    await initializeScouters();
    doesHaveUnsavedScoutersChanges = false;
    notifyListeners();
  }

  void discardUnitsChanges() async {
    await initializeUnits();
    doesHaveUnsavedUnitsChanges = false;
    notifyListeners();
  }

  void initializeData() async {
    await initializeScouters();
    await initializeUnits();
    notifyListeners();
  }

  Future<void> initializeScouters() async {
    final scoutersSnapshot = await scoutersDoc.get();
    if (!scoutersSnapshot.exists || scoutersSnapshot.data() == null) return;
    scouters = Scouter.scoutersListFromMap(
      List.of(scoutersSnapshot.data()!['scouters']),
    );
  }

  Future<void> initializeUnits() async {
    final unitsSnapshot = await unitsDoc.get();
    if (!unitsSnapshot.exists || unitsSnapshot.data() == null) {
      day1Units = [];
      day2Units = [];
      return;
    }
    final data = unitsSnapshot.data()!;
    day1Units = ScoutingUnit.scoutingUnitsListFromMap(
      List.of(data["day1Units"]),
    );
    day2Units = ScoutingUnit.scoutingUnitsListFromMap(
      List.of(data["day2Units"]),
    );
  }

  void listenData() {
    scoutersSubscriber = scoutersDoc.snapshots().listen(onScoutersSnapshot);
    unitsSubscriber = unitsDoc.snapshots().listen(onUnitsSnapshot);
    notifyListeners();
  }

  void onScoutersSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc.exists && doc.data() != null) {
      scouters = Scouter.scoutersListFromMap(List.of(doc.data()!['scouters']));
    } else {
      scouters = null;
    }
    notifyListeners();
  }

  void onUnitsSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      day1Units = ScoutingUnit.scoutingUnitsListFromMap(
        List.of(data["day1Units"]),
      );
      day2Units = ScoutingUnit.scoutingUnitsListFromMap(
        List.of(data["day2Units"]),
      );
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
