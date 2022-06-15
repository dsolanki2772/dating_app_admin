// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_account_settings_model.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/block_user_provider.dart';
import 'package:mio_amore/providers/user_profile_provider.dart';

final filteredOtherUsersProvider =
    FutureProvider<List<UserProfileModel>>((ref) async {
  List<UserProfileModel> usersList = [];

  final otherUsers = ref.watch(otherUsersProvider);

  otherUsers.whenData((value) {
    usersList.addAll(value);
  });

  final myProfileProvider = ref.watch(userProfileFutureProvider);

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

        bool isWorldWide = mySettings.distanceInKm == null;

        bool isDistanceOk = isWorldWide ||
            (mySettings.distanceInKm! >= distanceBetweenMeAndUser);

        if (userAge >= mySettings.minimumAge &&
            userAge <= mySettings.maximumAge &&
            isDistanceOk) {
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

final notShowingUsersProvider = Provider<String>((ref) {
  List<UserProfileModel> usersList = [];

  final otherUsers = ref.watch(otherUsersProvider);

  otherUsers.whenData((value) {
    usersList.addAll(value);
  });

  final myProfileProvider = ref.watch(userProfileFutureProvider);

  List<ClosestUser> closestUsers = [];

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
            userAge <= mySettings.maximumAge) {
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
          closestUsers
              .add(ClosestUser(user: user, distance: distanceBetweenMeAndUser));
        }
      }
    }
  });

  closestUsers.sort((a, b) => a.distance.compareTo(b.distance));

  String returnText = closestUsers.isEmpty
      ? "There are no users that match your criteria"
      : "There are no users that match your criteria. But you can still see other users nearby. So many other users who are ${closestUsers.first.distance.toStringAsFixed(0)} KM away waiting for you to meet them. Explore and find them!";
  return returnText;
});

class ClosestUser {
  UserProfileModel user;
  double distance;
  ClosestUser({
    required this.user,
    required this.distance,
  });
}

final otherUsersProvider = FutureProvider<List<UserProfileModel>>((ref) async {
  final allOtherUsers = await getAllOtherUsers();

  final List<String> blockedUsersIds = [];
  final usersIblocked = await getBlockUsers();
  for (var user in usersIblocked) {
    blockedUsersIds.add(user.blockedUserId);
  }
  final usersWhoBlockedMe = await getUsersWhoBlockedMe();
  for (var user in usersWhoBlockedMe) {
    blockedUsersIds.add(user.blockedByUserId);
  }

  final filteredUsers = allOtherUsers.where((user) {
    return !blockedUsersIds.contains(user.userId);
  }).toList();

  return filteredUsers;
});

final otherUsersWithoutBlockedProvider =
    FutureProvider<List<UserProfileModel>>((ref) async {
  return await getAllOtherUsers();
});

Future<List<UserProfileModel>> getAllOtherUsers() async {
  final userCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userProfileCollection);
  final myUserId = FirebaseAuth.instance.currentUser!.uid;

  final otherUsers =
      await userCollection.where("userId", isNotEqualTo: myUserId).get();

  final allOtherUsers = otherUsers.docs.map((doc) {
    return UserProfileModel.fromMap(doc.data());
  }).toList();

  return allOtherUsers;
}
