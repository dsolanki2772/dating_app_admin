class FirebaseConstants {
  FirebaseConstants._();

  static const String adminCollection = 'admin';

  static const String userProfileCollection = "userProfile";
  static const String userInteractionCollection = "userInteraction";
  static const String matchCollection = "matches";
  static const String chatCollection = "chat";
  static const String verificationFormsCollection = "verificationForms";
  static const String feedsCollection = "feeds";
  static const String deviceTokensCollection = "deviceTokens";
  static const String notificationsCollection = "notifications";
  static const String blockedUsersCollection = "blockedUsers";
  static const String reportsCollection = "reports";
  static const String bannedUsersCollection = "bannedUsers";
  static const String accountDeleteRequestCollection = "accountDeleteRequest";
}


// // Crate a function to delete all the collections in the database except the admin collection

// Future<void> deleteAllCollections() async {

//   final firestore = FirebaseFirestore.instance;

//   final userProfileCollection = firestore.collection(FirebaseConstants.userProfileCollection);
//   final userInteractionCollection = firestore.collection(FirebaseConstants.userInteractionCollection);
//   final matchCollection = firestore.collection(FirebaseConstants.matchCollection);
//   final chatCollection = firestore.collection(FirebaseConstants.chatCollection);
//   final verificationFormsCollection = firestore.collection(FirebaseConstants.verificationFormsCollection);
//   final feedsCollection = firestore.collection(FirebaseConstants.feedsCollection);
//   final deviceTokensCollection = firestore.collection(FirebaseConstants.deviceTokensCollection);
//   final notificationsCollection = firestore.collection(FirebaseConstants.notificationsCollection);
//   final blockedUsersCollection = firestore.collection(FirebaseConstants.blockedUsersCollection);

// }