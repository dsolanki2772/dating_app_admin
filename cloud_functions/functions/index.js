const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();


exports.addMatchingNotification = functions.firestore.document('matchingNotifications/{notiID}').onCreate(async (snap, context) => {
  const title = snap.data().title;
  const body = snap.data().body;
  const userId = snap.data().machedUserId;

  const getDeviceTokensPromise = db.collection("deviceTokens").where("userId", "==", userId).get();

  const result = await Promise.all([getDeviceTokensPromise]);
  const tokens = result[0].docs.map(doc => doc.data().deviceToken);

  const payload = {
    notification: {
      title: title,
      body: body,
      sound: "default",
    }
  };

  // Send notifications to all tokens.
  const response = await admin.messaging().sendToDevice(tokens, payload);
  response.results.forEach((result, index) => {
    const error = result.error;
    if (error) {
      functions.logger.error(
        'Failure sending notification to',
        tokens[index],
        error
      );
    }
  });

  return Promise.resolve();
});

