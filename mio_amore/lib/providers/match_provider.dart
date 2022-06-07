import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/helpers/encrypt_helper.dart';
import 'package:mio_amore/models/chat_item_model.dart';
import 'package:mio_amore/models/match_model.dart';
import 'package:mio_amore/providers/interaction_provider.dart';

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

final _matchCollection =
    FirebaseFirestore.instance.collection(FirebaseConstants.matchCollection);

Future<bool> createConversation(MatchModel match) async {
  try {
    await _matchCollection.doc(match.id).set(match.toMap());

    final _chatCollection = FirebaseFirestore.instance
        .collection(FirebaseConstants.matchCollection)
        .doc(match.id)
        .collection(FirebaseConstants.chatCollection);
    final _currentTime = DateTime.now();
    final ChatItemModel _chatItemModel = ChatItemModel(
      id: _currentTime.millisecondsSinceEpoch.toString(),
      message: encryptText("Say Hi!"),
      matchId: match.id,
      createdAt: _currentTime,
      isRead: true,
    );
    await _chatCollection
        .doc(_currentTime.millisecondsSinceEpoch.toString())
        .set(_chatItemModel.toMap());

    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> unMatchUser(String matchId, String userId1, String userId2) async {
  final _interactionId1 = userId1 + userId2;
  final _interactionId2 = userId2 + userId1;
  try {
    await _matchCollection.doc(matchId).delete();
    await deleteInteraction(_interactionId1);
    await deleteInteraction(_interactionId2);

    return true;
  } catch (e) {
    return false;
  }
}
