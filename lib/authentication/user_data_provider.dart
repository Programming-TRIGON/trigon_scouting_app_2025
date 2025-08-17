import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../utilities/firebase_handler.dart';

enum UserRole {
  admin,
  shiftManager,
  viewer,
  scouter;

  String capitalizedName() {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  bool get hasViewerAccess => (index <= viewer.index);

  bool get hasScoutingAdminAccess => (index <= shiftManager.index);
}

class UserDataProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isDataLoading = true;
  String? _error;
  User? _user;
  UserRole? _role;

  bool get isDataLoading => _isDataLoading;

  String? get error => _error;

  User? get user => _user;

  UserRole? get role => _role;

  StreamSubscription<DocumentSnapshot>? _roleSubscriber;

  UserDataProvider() {
    _firebaseAuth.authStateChanges().listen(
      onData,
      onError: (err) {
        _error = err.toString();
        _isDataLoading = false;
        notifyListeners();
      },
    );
  }

  void onData(User? firebaseUser) {
    _user = firebaseUser;
    _error = null;
    _roleSubscriber?.cancel();

    if (_user != null) {
      listenToRole();
    } else {
      _isDataLoading = false;
      notifyListeners();
    }
  }

  void listenToRole() {
    _isDataLoading = true;
    notifyListeners();

    _roleSubscriber = _firestore
        .collection("users")
        .doc(_user!.uid)
        .snapshots()
        .listen(
          (doc) {
            if (doc.exists && doc.data() != null) {
              _role = UserRole.values.byName(doc.data()!["role"]);
            } else {
              _role = null;
            }
            _isDataLoading = false;
            notifyListeners();
          },
          onError: (e) {
            _error = 'Failed to load permissions: $e';
            _isDataLoading = false;
            notifyListeners();
          },
        );
  }

  Future<void> signOut() async {
    await FirebaseHandler.signOut();
  }

  @override
  void dispose() {
    _roleSubscriber?.cancel();
    super.dispose();
  }
}
