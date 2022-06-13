import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_account_settings_model.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/user_profile_provider.dart';

final filteredOtherUsersProvider =
    FutureProvider<List<UserProfileModel>>((ref) async {
  List<UserProfileModel> usersList = [];

  final otherUsers = ref.watch(otherUsersProvider);

  otherUsers.whenData((value) {
    usersList.addAll(value);
  });

  final myProfileProvider = ref.watch(userProfileStreamProvider);

  List<UserProfileModel> filteredUserList = [];

  myProfileProvider.whenData((value) {
    if (value != null) {
      final UserAccountSettingsModel mySettings =
          value.userAccountSettingsModel;

      for (var user in usersList) {
        bool willBeShown = false;
        bool isBoth = false;

        final userAge = DateTime.now().difference(user.birthDay).inDays ~/ 365;
        final userLocation = user.userAccountSettingsModel.location;
        final userGender = user.gender;

        double distanceBetweenMeAndUser = Geolocator.distanceBetween(
                mySettings.location.latitude,
                mySettings.location.longitude,
                userLocation.latitude,
                userLocation.longitude) /
            1000;

        if (mySettings.interestedIn == null) {
          isBoth = true;
        }

        if (userAge >= mySettings.minimumAge &&
            userAge <= mySettings.maximumAge &&
            mySettings.distanceInKm >= distanceBetweenMeAndUser) {
          if (isBoth) {
            willBeShown = true;
          } else {
            if (mySettings.interestedIn == userGender) {
              willBeShown = true;
            } else {
              willBeShown = false;
            }
          }
        }

        if (willBeShown) {
          filteredUserList.add(user);
        }
      }
    }
  });

  return filteredUserList;
});

final otherUsersProvider = FutureProvider<List<UserProfileModel>>((ref) async {
  final userCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userProfileCollection);
  final myUserId = FirebaseAuth.instance.currentUser!.uid;

  final otherUsers =
      await userCollection.where("userId", isNotEqualTo: myUserId).get();

  return otherUsers.docs.map((doc) {
    return UserProfileModel.fromMap(doc.data());
  }).toList();
});
