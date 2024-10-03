import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mioamoreadmin/helpers/firebase_constants.dart';
import 'package:mioamoreadmin/models/user_profile_model.dart';
import 'package:mioamoreadmin/providers/user_profiles_provider.dart';

class ResetDatabaseProvider {
  static Future<bool> start() async {
    try {
      // Delete all user profiles
      EasyLoading.show(status: "Deleting all user profiles");
      final userProfileCollection = FirebaseFirestore.instance
          .collection(FirebaseConstants.userProfileCollection);

      await userProfileCollection.get().then((snapshot) async {
        for (DocumentSnapshot ds in snapshot.docs) {
          EasyLoading.show(status: "Deleting user profile ${ds.id}");
          await ds.reference.delete();
        }
      });

      // Delete all device tokens
      EasyLoading.show(status: "Deleting all device tokens");
      final deviceTokenCollection = FirebaseFirestore.instance
          .collection(FirebaseConstants.deviceTokensCollection);

      await deviceTokenCollection.get().then((snapshot) async {
        for (DocumentSnapshot ds in snapshot.docs) {
          EasyLoading.show(status: "Deleting device token ${ds.id}");
          await ds.reference.delete();
        }
      });

      // Delete all interactions
      EasyLoading.show(status: "Deleting all interactions");
      final interactionsCollection = FirebaseFirestore.instance
          .collection(FirebaseConstants.userInteractionCollection);

      await interactionsCollection.get().then((snapshot) async {
        for (DocumentSnapshot ds in snapshot.docs) {
          EasyLoading.show(status: "Deleting interaction ${ds.id}");
          await ds.reference.delete();
        }
      });

      // Delete all matches
      EasyLoading.show(status: "Deleting all matches");
      final matchesCollection = FirebaseFirestore.instance
          .collection(FirebaseConstants.matchCollection);

      await matchesCollection.get().then((snapshot) async {
        for (DocumentSnapshot ds in snapshot.docs) {
          EasyLoading.show(status: "Deleting match ${ds.id}");
          await ds.reference.delete();
        }
      });

      // Delete all feeds
      EasyLoading.show(status: "Deleting all feeds");
      final feedsCollection = FirebaseFirestore.instance
          .collection(FirebaseConstants.feedsCollection);

      await feedsCollection.get().then((snapshot) async {
        for (DocumentSnapshot ds in snapshot.docs) {
          EasyLoading.show(status: "Deleting feed ${ds.id}");
          await ds.reference.delete();
        }
      });

      // Delete all reports
      EasyLoading.show(status: "Deleting all reports");
      final reportsCollection = FirebaseFirestore.instance
          .collection(FirebaseConstants.reportsCollection);

      await reportsCollection.get().then((snapshot) async {
        for (DocumentSnapshot ds in snapshot.docs) {
          EasyLoading.show(status: "Deleting report ${ds.id}");
          await ds.reference.delete();
        }
      });

      // Delete all blocked users
      EasyLoading.show(status: "Deleting all blocked users");
      final blockedUsersCollection = FirebaseFirestore.instance
          .collection(FirebaseConstants.blockedUsersCollection);

      await blockedUsersCollection.get().then((snapshot) async {
        for (DocumentSnapshot ds in snapshot.docs) {
          EasyLoading.show(status: "Deleting blocked user ${ds.id}");
          await ds.reference.delete();
        }
      });

      // Delete all banned users
      EasyLoading.show(status: "Deleting all banned users");
      final bannedUsersCollection = FirebaseFirestore.instance
          .collection(FirebaseConstants.bannedUsersCollection);

      await bannedUsersCollection.get().then((snapshot) async {
        for (DocumentSnapshot ds in snapshot.docs) {
          EasyLoading.show(status: "Deleting banned user ${ds.id}");
          await ds.reference.delete();
        }
      });

      // Delete all account delete requests
      EasyLoading.show(status: "Deleting all account delete requests");
      final accountDeleteRequestsCollection = FirebaseFirestore.instance
          .collection(FirebaseConstants.accountDeleteRequestCollection);

      await accountDeleteRequestsCollection.get().then((snapshot) async {
        for (DocumentSnapshot ds in snapshot.docs) {
          await ds.reference.delete();
        }
      });

      // Delete all notifications
      EasyLoading.show(status: "Deleting all notifications");
      final notificationsCollection = FirebaseFirestore.instance
          .collection(FirebaseConstants.notificationsCollection);

      await notificationsCollection.get().then((snapshot) async {
        for (DocumentSnapshot ds in snapshot.docs) {
          EasyLoading.show(status: "Deleting notification ${ds.id}");
          await ds.reference.delete();
        }
      });

      // delete all verification forms
      EasyLoading.show(status: "Deleting all verification forms");
      final verificationFormsCollection = FirebaseFirestore.instance
          .collection(FirebaseConstants.verificationFormsCollection);

      await verificationFormsCollection.get().then((snapshot) async {
        for (DocumentSnapshot ds in snapshot.docs) {
          await ds.reference.delete();
        }
      });

      final randomUsersJsonData =
          await rootBundle.loadString('assets/json/random_users.json');
      final randomUsersJson = jsonDecode(randomUsersJsonData) as List;
      final List<UserProfileModel> userProfiles = [];
      for (var element in randomUsersJson) {
        userProfiles.add(UserProfileModel.fromMap(element));
      }

      EasyLoading.show(status: "Adding new user profiles");
      for (var userProfile in userProfiles) {
        EasyLoading.show(status: "Adding user profile ${userProfile.id}");
        await UserProfileProvider.addUser(userProfile);
      }

      EasyLoading.showSuccess("Database reset successfully");

      return true;
    } catch (e) {
      EasyLoading.showError("There was an error resetting the database");
      debugPrint(e.toString());
      return false;
    }
  }
}
