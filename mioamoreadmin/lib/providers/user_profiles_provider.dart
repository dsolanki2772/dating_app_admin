import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mioamoreadmin/helpers/firebase_constants.dart';
import 'package:mioamoreadmin/models/user_profile_model.dart';

final userProfileProvider =
    FutureProvider.family<UserProfileModel, String>((ref, userId) async {
  final userProfileCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userProfileCollection);
  final userProfileDoc = await userProfileCollection.doc(userId).get();
  final userProfileData = userProfileDoc.data();
  if (userProfileData != null) {
    return UserProfileModel.fromMap(userProfileData);
  } else {
    throw Exception('User profile not found!');
  }
});

final usersShortStreamProvider =
    StreamProvider<List<UserProfileShortModel>>((ref) {
  final usersCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userProfileCollection);

  return usersCollection.snapshots().map((snapshot) => snapshot.docs
      .map((doc) => UserProfileShortModel.fromMap(doc.data()))
      .toList());
});
