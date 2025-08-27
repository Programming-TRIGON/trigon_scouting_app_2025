import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:trigon_scouting_app_2025/utilities/firebase_handler.dart';

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

class TRIGONUser {
  final String uid;
  final String name;
  final String email;
  final UserRole role;

  TRIGONUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });

  factory TRIGONUser.fromMap(String uid, Map<String, dynamic> data) {
    return TRIGONUser(
      uid: uid,
      name: data["name"] as String,
      email: data["email"] as String,
      role: UserRole.values.byName(data["role"] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "email": email, "role": role.name};
  }
}

class UserDataProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference<Map<String, dynamic>> usersCollection = firestore
      .collection("users");

  bool isDataLoading = true;
  User? user;
  List<TRIGONUser>? allUsers;
  UserRole? role;

  StreamSubscription<DocumentSnapshot>? roleSubscriber;

  UserDataProvider() {
    listenToData();
  }

  Future<void> signOut() async {
    await FirebaseHandler.signOut();
  }

  String? userNameFromUID(String uid) {
    return allUsers?.where((user) => user.uid == uid).firstOrNull?.name;
  }

  void listenToData() {
    firebaseAuth.authStateChanges().listen(onUserData);
  }

  void onUserData(User? firebaseUser) {
    user = firebaseUser;
    roleSubscriber?.cancel();

    if (user != null) {
      listenToRole();
      listenToAllUsers();
    } else {
      isDataLoading = false;
      notifyListeners();
    }
  }

  void listenToRole() {
    isDataLoading = true;
    notifyListeners();

    roleSubscriber = usersCollection
        .doc(user!.uid)
        .snapshots()
        .listen(onUserRoleData);
  }

  void listenToAllUsers() {
    isDataLoading = true;
    notifyListeners();

    usersCollection.snapshots().listen((querySnapshot) {
      allUsers = querySnapshot.docs.map((doc) => TRIGONUser.fromMap(doc.id, doc.data())).toList();
      isDataLoading = false;
      notifyListeners();
    });
  }

  void onUserRoleData(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc.exists && doc.data() != null) {
      role = UserRole.values.byName(doc.data()!["role"]);
    } else {
      role = null;
    }
    isDataLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    roleSubscriber?.cancel();
    super.dispose();
  }
}
