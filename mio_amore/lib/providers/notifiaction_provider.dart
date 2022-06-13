import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/notification_model.dart';

final notificationsStreamProvider =
    StreamProvider<List<NotificationModel>>((ref) {
  const matchingNotificationCollection =
      FirebaseConstants.notificationsCollection;

  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  return FirebaseFirestore.instance
      .collection(matchingNotificationCollection)
      .where("receiverId", isEqualTo: currentUserId)
      .orderBy("createdAt", descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => NotificationModel.fromMap(doc.data()))
        .toList();
  });
});

const _matchingNotificationCollection =
    FirebaseConstants.notificationsCollection;

Future<bool> addNotification(NotificationModel notificationModel) async {
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
Future<bool> updateNotification(NotificationModel notificationModel) async {
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
