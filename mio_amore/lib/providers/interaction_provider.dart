import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_interaction_model.dart';
import 'package:twitter_login/entity/user.dart';

final interactionFutureProvider =
    FutureProvider.autoDispose<List<UserInteractionModel>>((ref) async {
  final _interactionCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userInteractionCollection);

  return await _interactionCollection
      .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((snapshot) {
    final List<UserInteractionModel> _interactionList = [];
    for (var doc in snapshot.docs) {
      _interactionList.add(UserInteractionModel.fromMap(doc.data()));
    }
    return _interactionList;
  });
});

final interactionProvider = Provider<InteractionProvider>((ref) {
  return InteractionProvider();
});

class InteractionProvider {
  final _interactionCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userInteractionCollection);

  Future<bool> createInteraction(UserInteractionModel interaction) async {
    try {
      await _interactionCollection.doc(interaction.id).set(interaction.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserInteractionModel?> getExistingInteraction(
      String otherUserId) async {
    final _interactionCollection = FirebaseFirestore.instance
        .collection(FirebaseConstants.userInteractionCollection);

    return await _interactionCollection
        .where("id",
            isEqualTo: otherUserId + FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return UserInteractionModel.fromMap(snapshot.docs.first.data());
    });
  }
}
