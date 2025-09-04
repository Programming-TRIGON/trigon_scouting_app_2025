import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trigon_scouting_app_2025/authentication/user_data_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouted_competition/scouted_competition.dart';
import 'package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_report.dart';
import 'package:trigon_scouting_app_2025/utilities/tba_handler.dart';

class FirebaseHandler {
  static final authInstance = FirebaseAuth.instance;
  static final firestore = FirebaseFirestore.instance;

  static Future<void> initializeFirebase() async {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyDH2yUwQJG0UsR7riCz2aQ9lRcWU3PzOME',
          authDomain: 'trigon-scouting-app.firebaseapp.com',
          projectId: 'trigon-scouting-app',
          storageBucket: 'trigon-scouting-app.firebasestorage.app',
          messagingSenderId: '682214703186',
          appId: '1:682214703186:web:f3006ab8a0be69bd859f8b',
          measurementId: 'G-CVCRZMR25N',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  }

  static Future<User?> signUp(
    String email,
    String password,
    String name,
    UserRole role,
  ) async {
    try {
      final cred = await authInstance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await cred.user!.updateDisplayName(name);
      await firestore.collection('users').doc(cred.user!.uid).set({
        'name': name,
        'email': email.trim(),
        'role': role.name,
      });
      return cred.user;
    } catch (e) {
      log('Something went wrong.');
    }

    return null;
  }

  static Future<User?> logInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final cred = await authInstance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return cred.user;
    } catch (e) {
      log('Something went wrong.');
    }

    return null;
  }

  static Future<void> signOut() async {
    try {
      await authInstance.signOut();
    } catch (e) {
      log('Something went wrong.');
    }
  }

  static Future<void> resetPassword({required BuildContext context, String? email}) async {
    email ??= authInstance.currentUser!.email!;
    try {
      await authInstance.sendPasswordResetEmail(email: email);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sent password reset to $email, check your inbox (and spam folder)!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      log('Something went wrong while resetting password. Stack trace:\n $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong while resetting password.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  static Future<void> setScoutedCompetition(FRCCompetition competition) async {
    final scoutedCompetitionDoc = firestore
        .collection('competitions')
        .doc('scoutedCompetition');
    await scoutedCompetitionDoc.set(competition.toMap());
  }

  static Future<ScoutedCompetition?> getScoutedCompetition() async {
    final docSnapshot = await firestore
        .collection('competitions')
        .doc('scoutedCompetition')
        .get();

    if (!docSnapshot.exists) return null;

    final data = docSnapshot.data();
    if (data == null) return null;

    return ScoutedCompetition.fromMap(Map<String, dynamic>.from(data));
  }

  static Future<void> uploadGameScoutingReport(
    GameScoutingReport report,
    String? competitionKey,
  ) async {
    if (competitionKey == null) return;

    final matchDocument = FirebaseFirestore.instance
        .collection('competitions')
        .doc(competitionKey)
        .collection('teams')
        .doc(report.pregameReport.robotNumber!.toString())
        .collection('games')
        .doc(report.pregameReport.getMatchKey());
    await matchDocument.set(report.toMap());
  }
}
