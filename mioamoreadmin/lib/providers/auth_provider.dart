import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authstateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges().map((event) {
    ref.read(currentUserProvider.notifier).state = event;
    return event;
  });
});

final currentUserProvider = StateProvider<User?>((ref) {
  return null;
});

class AuthProvider {
  static Future<User?> loginWithEmailAndPass(
      {required String email, required String password}) async {
    try {
      EasyLoading.show(status: 'Logging in...');
      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      EasyLoading.dismiss();
      return user.user;
    } catch (e) {
      debugPrint(e.toString());

      String error = e.toString().split(']')[1].trim();
      EasyLoading.showError(error);
      return null;
    }
  }

  static Future<User?> registerWithEmailAndPass(
      {required String email, required String password}) async {
    try {
      EasyLoading.show(status: 'Registering...');
      final user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      EasyLoading.dismiss();
      return user.user;
    } catch (e) {
      debugPrint(e.toString());

      String error = e.toString().split(']')[1].trim();

      EasyLoading.showError(error);
      return null;
    }
  }

  static Future<bool> forgotPassword({required String email}) async {
    try {
      EasyLoading.show(status: 'Sending reset password email...');
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      EasyLoading.dismiss();
      return true;
    } catch (e) {
      debugPrint(e.toString());

      String error = e.toString().split(']')[1].trim();

      EasyLoading.showError(error);
      return false;
    }
  }

  static Future<bool> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
