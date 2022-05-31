import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/notification_model.dart';

final matchingNotificationsStreamProvider =
    StreamProvider<List<MatchingNotificationModel>>((ref) {
  const _matchingNotificationCollection =
      FirebaseConstants.matchingNotificationsCollection;

  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  return FirebaseFirestore.instance
      .collection(_matchingNotificationCollection)
      .where("machedUserId", isEqualTo: _currentUserId)
      .orderBy("createdAt", descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => MatchingNotificationModel.fromMap(doc.data()))
        .toList();
  });
});

final matchingNotificationProvider =
    Provider<MatchingNotificationProvider>((ref) {
  return MatchingNotificationProvider();
});

class MatchingNotificationProvider {
  final _matchingNotificationCollection =
      FirebaseConstants.matchingNotificationsCollection;

  Future<bool> addNotification(
      MatchingNotificationModel notificationModel) async {
    try {
      await FirebaseFirestore.instance
          .collection(_matchingNotificationCollection)
          .doc(notificationModel.id)
          .set(notificationModel.toMap());

      return true;
    } catch (e) {
      return false;
    }
  }

  //Update notification
  Future<bool> updateNotification(
      MatchingNotificationModel notificationModel) async {
    try {
      await FirebaseFirestore.instance
          .collection(_matchingNotificationCollection)
          .doc(notificationModel.id)
          .update(notificationModel.toMap());

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteNotification(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection(_matchingNotificationCollection)
          .doc(notificationId)
          .delete();

      return true;
    } catch (e) {
      return false;
    }
  }
}
