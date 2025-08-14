import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:trigon_scouting_app_2025/utilities/tba_handler.dart';

import '../utilities/firebase_handler.dart';

class ScoutedCompetitionProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FRCCompetition? scoutedCompetition;
  StreamSubscription<DocumentSnapshot>? _scoutedCompetitionSubscriber;

  ScoutedCompetitionProvider() {
    FirebaseHandler.getScoutedCompetition().then(
            (value) => scoutedCompetition = value
    );
    listenToRole();
  }

  void listenToRole() {
    notifyListeners();

    _scoutedCompetitionSubscriber = _firestore
        .collection("competitions")
        .doc("scoutedCompetition")
        .snapshots()
        .listen(
          (doc) {
        if (doc.exists && doc.data() != null) {
          scoutedCompetition = FRCCompetition.fromMap(Map<String, dynamic>.from(doc.data()!));
        } else {
          scoutedCompetition = null;
        }
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _scoutedCompetitionSubscriber?.cancel();
    super.dispose();
  }
}
