import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';

final favouriteUsersStreamProvider = StreamProvider<List<String>>((ref) {
  final _userId = FirebaseAuth.instance.currentUser!.uid;
  final _favouriteUsersCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userProfileCollection)
      .doc(_userId)
      .collection(FirebaseConstants.favouriteUsersCollection);

  return _favouriteUsersCollection.snapshots().map((event) {
    return event.docs.map((doc) {
      return doc.id;
    }).toList();
  });
});

final favouriteUsersProvider = Provider<FavouriteUsersProvider>((ref) {
  return FavouriteUsersProvider();
});

class FavouriteUsersProvider {
  Future<bool> addToFavourite(String id) async {
    final _userId = FirebaseAuth.instance.currentUser!.uid;
    final _favouriteUsersCollection = FirebaseFirestore.instance
        .collection(FirebaseConstants.userProfileCollection)
        .doc(_userId)
        .collection(FirebaseConstants.favouriteUsersCollection);

    try {
      await _favouriteUsersCollection.doc(id).set({"isFavourite": true});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromFavourite(String id) async {
    final _userId = FirebaseAuth.instance.currentUser!.uid;
    final _favouriteUsersCollection = FirebaseFirestore.instance
        .collection(FirebaseConstants.userProfileCollection)
        .doc(_userId)
        .collection(FirebaseConstants.favouriteUsersCollection);

    try {
      await _favouriteUsersCollection.doc(id).delete();

      return true;
    } catch (e) {
      return false;
    }
  }
}
