import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mioamoreadmin/helpers/firebase_constants.dart';
import 'package:mioamoreadmin/models/match_model.dart';

final totalMatchesProvider = StreamProvider<List<MatchModel>>((ref) {
  final collection =
      FirebaseFirestore.instance.collection(FirebaseConstants.matchCollection);

  return collection.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return MatchModel.fromMap(doc.data());
    }).toList();
  });
});
