import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mioamoreadmin/helpers/firebase_constants.dart';
import 'package:mioamoreadmin/models/account_delete_request_model.dart';
import 'package:mioamoreadmin/providers/devices_provider.dart';
import 'package:mioamoreadmin/providers/feeds_provider.dart';
import 'package:mioamoreadmin/providers/interactions_provider.dart';
import 'package:mioamoreadmin/providers/notification_provider.dart';
import 'package:mioamoreadmin/providers/user_profiles_provider.dart';
import 'package:mioamoreadmin/providers/user_reports_provider.dart';
import 'package:mioamoreadmin/providers/user_verification_forms_provider.dart';

final accountDeleteRequestsProvider =
    FutureProvider<List<AccountDeleteRequestModel>>((ref) async {
  final collection = FirebaseFirestore.instance
      .collection(FirebaseConstants.accountDeleteRequestCollection);

  return collection.get().then((value) {
    return value.docs
        .map((e) => AccountDeleteRequestModel.fromMap(e.data()))
        .toList();
  });
});

class AccountDeleteRequestProvider {
  static Future<bool> deleteRequest(String userId) async {
    final collection = FirebaseFirestore.instance
        .collection(FirebaseConstants.accountDeleteRequestCollection);

    try {
      await collection.doc(userId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete user account from database

  // delete all deviceTokens
  // delete all feeds
  // Delete all notifications - userId
  // delete all reports
  // delete all interactions
  // delete userProfile
  // delete verification form of the user

  //TODO: Delete all the chats of the user
  // TODO: Delete all the matches of the user
  // TODO: Delete all the images uploaded by the user!

  static Future<bool> deleteUser(String userId) async {
    try {
      await DevicesProvider.deleteDevices(userId);
      await FeedsProvider.deleteFeeds(userId);
      await NotificaitonProvider.deleteNotifications(userId);
      await UserReportsProvider.deleteReports(userId);
      await InteractionsProvider.deleteInteractions(userId);
      await UserProfileProvider.deleteUser(userId);
      await VerificationProvider.deleteForm(userId);
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }
}
