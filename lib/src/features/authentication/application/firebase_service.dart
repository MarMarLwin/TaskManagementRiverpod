import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:task_management/src/features/authentication/domain/app_user.dart';
import 'package:task_management/src/features/task/domain/task.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AppUser?> signUpWithEmailPassword(
      String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (credential.user != null) {
      final user = credential.user;
      return AppUser(uid: user!.uid, email: user.email ?? '', password: '');
    } else {
      return null;
    }
  }

  Future<AppUser?> signInWithEmailPassword(
      String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    if (credential.user != null) {
      var user = credential.user;
      return AppUser(uid: user!.uid, email: user.email ?? '', password: '');
    } else {
      return null;
    }
  }

  Future<void> signOutWithPassword() async {
    await _auth.signOut();

    debugPrint("User Signed Out");
  }

  Future<void> createTask(AppTask task) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('tasks');

    databaseReference.push().set(task.toJson());
  }
}

// final firebaseServiceProvider = Provider<FirebaseService>((ref) {
//   return FirebaseService(ref);
// });
