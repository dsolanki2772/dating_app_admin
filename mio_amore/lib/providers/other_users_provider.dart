import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_account_settings_model.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/user_interaction_provider.dart';
import 'package:mio_amore/providers/user_profile_provider.dart';

final filteredOtherUsersProvider =
    FutureProvider<List<UserProfileModel>>((ref) async {
  List<UserProfileModel> _usersList = [];

  final _otherUsersProvider = ref.watch(otherUsersProvider);

  _otherUsersProvider.whenData((value) {
    _usersList.addAll(value);
  });

  final _myProfileProvider = ref.watch(userProfileStreamProvider);

  List<UserProfileModel> _filteredUserList = [];

  _myProfileProvider.whenData((value) {
    if (value != null) {
      final UserAccountSettingsModel _mySettings =
          value.userAccountSettingsModel;

      for (var user in _usersList) {
        bool _willBeShown = false;
        bool _isBoth = false;

        final _userAge = DateTime.now().difference(user.birthDay).inDays ~/ 365;
        final _userLocation = user.userAccountSettingsModel.location;
        final _userGender = user.gender;

        double _distanceBetweenMeAndUser = Geolocator.distanceBetween(
                _mySettings.location.latitude,
                _mySettings.location.longitude,
                _userLocation.latitude,
                _userLocation.longitude) /
            1000;

        if (_mySettings.interestedIn == null) {
          _isBoth = true;
        }

        if (_userAge >= _mySettings.minimumAge &&
            _userAge <= _mySettings.maximumAge &&
            _mySettings.distanceInKm >= _distanceBetweenMeAndUser) {
          if (_isBoth) {
            _willBeShown = true;
          } else {
            if (_mySettings.interestedIn == _userGender) {
              _willBeShown = true;
            } else {
              _willBeShown = false;
            }
          }
        }

        if (_willBeShown) {
          _filteredUserList.add(user);
        }
      }
    }
  });

  // final _userIneractionFutureProvider = ref.watch(userIneractionFutureProvider);

  // List<UserProfileModel> _filteredUserListWithInteraction = [];

  // _userIneractionFutureProvider.whenData((value) {
  //   print("value: $value");

  //   for (var user in _filteredUserList) {
  //     for (var element in value) {
  //       if (!element.userIds.contains(user.id)) {
  //         _filteredUserListWithInteraction.add(user);
  //       }

  //       if (element.userIds.contains(user.id)) {
  //         final _myUserId = FirebaseAuth.instance.currentUser!.uid;

  //         if (!element.interactions.any((e) => e.userId == _myUserId)) {
  //           _filteredUserListWithInteraction.add(user);
  //         }
  //       }
  //     }
  //   }
  // });

  // print(
  //     'filteredUserListWithInteraction: ${_filteredUserListWithInteraction.length}');

  return _filteredUserList;
});

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
