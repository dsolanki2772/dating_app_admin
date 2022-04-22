import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_profile_model.dart';

final otherUsersProvider = FutureProvider<List<UserProfileModel>>((ref) async {
  final _userCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userProfileCollection);

  final _myUserId = FirebaseAuth.instance.currentUser!.uid;
  final _otherUsers =
      await _userCollection.where("userId", isNotEqualTo: _myUserId).get();

  return _otherUsers.docs.map((doc) {
    return UserProfileModel.fromMap(doc.data());
  }).toList();
});
