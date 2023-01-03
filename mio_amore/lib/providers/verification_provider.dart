import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/get_verified_model.dart';

final verificationProvider =
    ChangeNotifierProvider<VerificationProvider>((ref) {
  return VerificationProvider();
});

class VerificationProvider extends ChangeNotifier {
  final _verificationCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.verificationFormsCollection);

  //Verification
  Future<GetVerifiedModel?> getVerifiedStatus() async {
    return _verificationCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      print("Value: ${value.data()}");

      if (value.exists) {
        return GetVerifiedModel.fromMap(value.data()!);
      } else {
        return null;
      }
    });
  }

  Future<void> submitVerificationForm(GetVerifiedModel model) async {
    try {
      await _verificationCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(model.toMap());
      notifyListeners();
    } catch (e) {
      EasyLoading.showError("Something went wrong!");
    }
  }

  Future<void> updateVerificationForm(GetVerifiedModel model) async {
    try {
      await _verificationCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(model.toMap());
      notifyListeners();
    } catch (e) {
      EasyLoading.showError("Something went wrong!");
    }
  }
}
