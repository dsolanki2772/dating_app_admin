import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_profile_model.dart';

final userProfileStreamProvider = StreamProvider<UserProfileModel?>((ref) {
  final _userCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userProfileCollection);

  return _userCollection
      .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots()
      .map((event) {
    if (event.docs.isEmpty) {
      return null;
    } else {
      return UserProfileModel.fromMap(event.docs.first.data());
    }
  });
});

final userProfileProvider = Provider<UserProfileProvider>((ref) {
  return UserProfileProvider();
});

class UserProfileProvider {
  final _userCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userProfileCollection);

  Future<bool> createUserProfile(UserProfileModel userProfileModel) async {
    try {
      UserProfileModel? _newUserProfile;

      if (userProfileModel.profilePicture != null) {
        if (Uri.parse(userProfileModel.profilePicture!).isAbsolute) {
          _newUserProfile = userProfileModel;
        } else {
          final _profileURL =
              await _uploadProfilePicture(userProfileModel.profilePicture!);
          _newUserProfile =
              userProfileModel.copyWith(profilePicture: _profileURL);
        }
      } else {
        _newUserProfile = userProfileModel;
      }

      await _userCollection
          .doc(_newUserProfile.id)
          .set(_newUserProfile.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserProfile(UserProfileModel userProfileModel) async {
    try {
      UserProfileModel? _newUserProfile;

      if (userProfileModel.profilePicture != null) {
        if (Uri.parse(userProfileModel.profilePicture!).isAbsolute) {
          _newUserProfile = userProfileModel;
        } else if (userProfileModel.profilePicture == "") {
          _newUserProfile = userProfileModel.copyWith(profilePicture: "");
        } else {
          final _profileURL =
              await _uploadProfilePicture(userProfileModel.profilePicture!);
          _newUserProfile =
              userProfileModel.copyWith(profilePicture: _profileURL);
        }
      } else {
        _newUserProfile = userProfileModel;
      }

      List<String> _mediaURLs = [];
      for (var media in userProfileModel.mediaFiles) {
        if (Uri.parse(media).isAbsolute) {
          _mediaURLs.add(media);
        } else if (media == "") {
          debugPrint("Media is empty");
        } else {
          final _mediaURL = await _uploadUserMediaFiles(media);
          if (_mediaURL != null) {
            _mediaURLs.add(_mediaURL);
          }
        }
      }

      final _anotherNewUserProfile =
          _newUserProfile.copyWith(mediaFiles: _mediaURLs);

      await _userCollection
          .doc(_anotherNewUserProfile.id)
          .update(_anotherNewUserProfile.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> _uploadProfilePicture(String imagePath) async {
    final _storageRef = FirebaseStorage.instance.ref();
    final _userId = FirebaseAuth.instance.currentUser!.uid;
    final _imageRef = _storageRef.child("user_profile_pictures/$_userId");
    final _uploadTask = _imageRef.putFile(File(imagePath));

    String? _imageUrl;
    await _uploadTask.whenComplete(() async {
      _imageUrl = await _imageRef.getDownloadURL();
    });
    return _imageUrl;
  }

  Future<String?> _uploadUserMediaFiles(String path) async {
    final _storageRef = FirebaseStorage.instance.ref();
    final _userId = FirebaseAuth.instance.currentUser!.uid;
    final _imageRef =
        _storageRef.child("user_media_files/$_userId/${path.split("/").last}");
    final _uploadTask = _imageRef.putFile(File(path));

    String? _imageUrl;
    await _uploadTask.whenComplete(() async {
      _imageUrl = await _imageRef.getDownloadURL();
    });
    return _imageUrl;
  }

  // Future<bool> deleteUserProfile(UserProfileModel userProfileModel) async {
  //   try {
  //     await _userCollection
  //         .doc(userProfileModel.id)
  //         .delete();
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }
}

Future<bool> isUserAdded(String userId) async {
  final _userCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userProfileCollection);
  bool _isUserAdded = false;
  await _userCollection.where("userId", isEqualTo: userId).get().then((event) {
    if (event.docs.isNotEmpty) {
      _isUserAdded = true;
    }
  });
  return _isUserAdded;
}

final isUserAddedProvider = FutureProvider((ref) async {
  final _userCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userProfileCollection);
  final _userId = FirebaseAuth.instance.currentUser!.uid;
  bool _isUserAdded = false;
  await _userCollection.where("userId", isEqualTo: _userId).get().then((event) {
    if (event.docs.isNotEmpty) {
      _isUserAdded = true;
    }
  });
  return _isUserAdded;
});
