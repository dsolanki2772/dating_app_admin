import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mioamoreadmin/helpers/firebase_constants.dart';
import 'package:mioamoreadmin/models/user_interaction_model.dart';

final totalInteractionsProvider =
    StreamProvider<List<UserInteractionModel>>((ref) {
  final collection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userInteractionCollection);

  return collection.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return UserInteractionModel.fromMap(doc.data());
    }).toList();
  });
});
