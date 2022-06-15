import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/block_user_model.dart';

final currentUserId = FirebaseAuth.instance.currentUser!.uid;
final blockUsersCollection = FirebaseFirestore.instance
    .collection(FirebaseConstants.blockedUsersCollection);

Future<List<BlockUserModel>> getBlockUsers() async {
  final blockUsers = await blockUsersCollection
      .where("blockedByUserId", isEqualTo: currentUserId)
      .get();
  final blockUsersList = blockUsers.docs.map((doc) {
    return BlockUserModel.fromMap(doc.data());
  }).toList();

  return blockUsersList;
}

Future<List<BlockUserModel>> getUsersWhoBlockedMe() async {
  final blockUsers = await blockUsersCollection
      .where("blockedUserId", isEqualTo: currentUserId)
      .get();
  final blockUsersList = blockUsers.docs.map((doc) {
    return BlockUserModel.fromMap(doc.data());
  }).toList();

  return blockUsersList;
}

final blockedUsersFutureProvider =
    FutureProvider<List<BlockUserModel>>((ref) async {
  return await getBlockUsers();
});

Future<bool> blockUser(String userId) async {
  final id = userId + currentUserId;
  try {
    await blockUsersCollection.doc(id).set(
          BlockUserModel(
            id: id,
            blockedByUserId: currentUserId,
            blockedUserId: userId,
            createdAt: DateTime.now(),
          ).toMap(),
        );
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> unblockUser(String blockId) async {
  try {
    await blockUsersCollection.doc(blockId).delete();
    return true;
  } catch (e) {
    return false;
  }
}
