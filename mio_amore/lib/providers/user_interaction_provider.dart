import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_interaction_model.dart';

final userIneractionFutureProvider =
    FutureProvider.autoDispose<List<UserInteractionModel>>((ref) {
  final _interactionCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userInteractionCollection);

  return _interactionCollection
      .where("userIds", arrayContains: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((event) {
    if (event.docs.isEmpty) {
      return [];
    } else {
      List<UserInteractionModel> _interactions = [];
      for (var element in event.docs) {
        _interactions.add(UserInteractionModel.fromMap(element.data()));
      }
      return _interactions;
    }
  });
});

final userInteractionProvider = Provider<UserInteractionProvider>((ref) {
  return UserInteractionProvider();
});

class UserInteractionProvider {
  final _interactionCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userInteractionCollection);

  Future<bool> createUserInteraction(UserInteractionModel interaction) async {
    try {
      await _interactionCollection.doc(interaction.id).set(interaction.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserInteraction(UserInteractionModel interaction) async {
    try {
      await _interactionCollection
          .doc(interaction.id)
          .update(interaction.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteUserInteraction(UserInteractionModel interaction) async {
    try {
      await _interactionCollection.doc(interaction.id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
