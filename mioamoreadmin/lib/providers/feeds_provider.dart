import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mioamoreadmin/helpers/firebase_constants.dart';

class FeedsProvider {
  static Future<bool> deleteFeeds(String userId) async {
    final collection = FirebaseFirestore.instance
        .collection(FirebaseConstants.feedsCollection);

    try {
      await collection.where('userId', isEqualTo: userId).get().then((value) {
        for (var element in value.docs) {
          element.reference.delete();
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
