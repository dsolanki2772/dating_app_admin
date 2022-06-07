import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/feed_model.dart';
import 'package:mio_amore/providers/match_provider.dart';

final getFeedsProvider = FutureProvider<List<FeedModel>>((ref) async {
  final _feedsCollection =
      FirebaseFirestore.instance.collection(FirebaseConstants.feedsCollection);
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final _machingProvider = ref.watch(matchStreamProvider);
  final List<String> _matchUserIds = [_currentUserId];

  _machingProvider.whenData((value) {
    final List<String> _otherUserIds = [];
    for (var element in value) {
      final _id = element.userIds.where((id) => id != _currentUserId);
      _otherUserIds.addAll(_id);
    }
    _matchUserIds.addAll(_otherUserIds);
  });

  final snapshot =
      await _feedsCollection.where('userId', whereIn: _matchUserIds).get();

  final List<FeedModel> feeds = [];
  for (final doc in snapshot.docs) {
    feeds.add(FeedModel.fromMap(doc.data()));
  }

  feeds.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return feeds;
});

final _feedsCollection =
    FirebaseFirestore.instance.collection(FirebaseConstants.feedsCollection);

Future<bool> addFeed(FeedModel feedModel) async {
  try {
    await _feedsCollection.doc(feedModel.id).set(feedModel.toMap());

    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> updateFeed(FeedModel feedModel) async {
  try {
    await _feedsCollection.doc(feedModel.id).update(feedModel.toMap());
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> deleteFeed(String id) async {
  try {
    await _feedsCollection.doc(id).delete();
    return true;
  } catch (e) {
    return false;
  }
}

Future<List<String>> uploadFeedImages(
    {required List<File> files, required String userId}) async {
  try {
    final List<String> urls = [];

    for (var element in files) {
      final _currentTime = DateTime.now();
      final _ref = FirebaseStorage.instance
          .ref()
          .child(FirebaseConstants.feedsCollection)
          .child(userId)
          .child(_currentTime.millisecondsSinceEpoch.toString() +
              userId +
              element.path.split('/').last);

      final _uploadTask = _ref.putFile(element);
      String? _url;
      await _uploadTask.whenComplete(() async {
        _url = await _ref.getDownloadURL();
      });

      if (_url != null) {
        urls.add(_url!);
      }
    }

    return urls;
  } catch (e) {
    return [];
  }
}
