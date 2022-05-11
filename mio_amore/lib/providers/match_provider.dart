import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/match_model.dart';

final matchStreamProvider = StreamProvider<List<MatchModel>>((ref) {
  final _matchCollection =
      FirebaseFirestore.instance.collection(FirebaseConstants.matchCollection);

  return _matchCollection
      .where("userIds", arrayContains: FirebaseAuth.instance.currentUser!.uid)
      .snapshots()
      .map((event) {
    return event.docs.map((doc) {
      return MatchModel.fromMap(doc.data());
    }).toList();
  });
});

final matchProvider = Provider<MatchProvider>((ref) {
  return MatchProvider();
});

class MatchProvider {
  final _matchCollection =
      FirebaseFirestore.instance.collection(FirebaseConstants.matchCollection);

  Future<bool> createConversation(MatchModel match) async {
    try {
      await _matchCollection.doc(match.id).set(match.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
}
