import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_profile_model.dart';

final userProfileStreamProvider = StreamProvider<UserProfileModel?>((ref) {
  final userCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userProfileCollection);

  return userCollection
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
      UserProfileModel? newUserProfile;

      if (userProfileModel.profilePicture != null) {
        if (Uri.parse(userProfileModel.profilePicture!).isAbsolute) {
          newUserProfile = userProfileModel;
        } else {
          final profileURL =
              await _uploadProfilePicture(userProfileModel.profilePicture!);
          newUserProfile =
              userProfileModel.copyWith(profilePicture: profileURL);
        }
      } else {
        newUserProfile = userProfileModel;
      }

      await _userCollection.doc(newUserProfile.id).set(newUserProfile.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserProfile(UserProfileModel userProfileModel) async {
    try {
      UserProfileModel? newUserProfile;

      if (userProfileModel.profilePicture != null) {
        if (Uri.parse(userProfileModel.profilePicture!).isAbsolute) {
          newUserProfile = userProfileModel;
        } else if (userProfileModel.profilePicture == "") {
          newUserProfile = userProfileModel.copyWith(profilePicture: "");
        } else {
          final profileURL =
              await _uploadProfilePicture(userProfileModel.profilePicture!);
          newUserProfile =
              userProfileModel.copyWith(profilePicture: profileURL);
        }
      } else {
        newUserProfile = userProfileModel;
      }

      List<String> mediaURLs = [];
      for (var media in userProfileModel.mediaFiles) {
        if (Uri.parse(media).isAbsolute) {
          mediaURLs.add(media);
        } else if (media == "") {
          debugPrint("Media is empty");
        } else {
          final mediaURL = await _uploadUserMediaFiles(media);
          if (mediaURL != null) {
            mediaURLs.add(mediaURL);
          }
        }
      }

      final anotherNewUserProfile =
          newUserProfile.copyWith(mediaFiles: mediaURLs);

      await _userCollection
          .doc(anotherNewUserProfile.id)
          .update(anotherNewUserProfile.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> _uploadProfilePicture(String imagePath) async {
    final storageRef = FirebaseStorage.instance.ref();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final imageRef = storageRef.child("user_profile_pictures/$userId");
    final uploadTask = imageRef.putFile(File(imagePath));

    String? imageUrl;
    await uploadTask.whenComplete(() async {
      imageUrl = await imageRef.getDownloadURL();
    });
    return imageUrl;
  }

  Future<String?> _uploadUserMediaFiles(String path) async {
    final storageRef = FirebaseStorage.instance.ref();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final imageRef =
        storageRef.child("user_media_files/$userId/${path.split("/").last}");
    final uploadTask = imageRef.putFile(File(path));

    String? imageUrl;
    await uploadTask.whenComplete(() async {
      imageUrl = await imageRef.getDownloadURL();
    });
    return imageUrl;
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
  final userCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userProfileCollection);
  bool isUserAdded = false;
  await userCollection.where("userId", isEqualTo: userId).get().then((event) {
    if (event.docs.isNotEmpty) {
      isUserAdded = true;
    }
  });
  return isUserAdded;
}

final isUserAddedProvider = FutureProvider((ref) async {
  final userCollection = FirebaseFirestore.instance
      .collection(FirebaseConstants.userProfileCollection);
  final userId = FirebaseAuth.instance.currentUser!.uid;
  bool isUserAdded = false;
  await userCollection.where("userId", isEqualTo: userId).get().then((event) {
    if (event.docs.isNotEmpty) {
      isUserAdded = true;
    }
  });
  return isUserAdded;
});
