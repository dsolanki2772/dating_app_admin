import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/device_model.dart';

class DeviceTokenProvider {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _deviceTokenCollection = FirebaseConstants.deviceTokensCollection;

  Future<String?> _getDeviceToken() async {
    String? deviceToken = await _firebaseMessaging.getToken();
    return deviceToken;
  }

  Future<void> saveDeviceToken() async {
    final _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final _token = await _getDeviceToken();
    if (_token != null) {
      final DeviceTokenModel _deviceToken = DeviceTokenModel(
        deviceToken: _token,
        userId: _currentUserId,
      );
      await FirebaseFirestore.instance
          .collection(_deviceTokenCollection)
          .doc(_deviceToken.deviceToken)
          .set(_deviceToken.toMap());
    }
  }

  Future<void> deleteDeviceToken() async {
    final _token = await _getDeviceToken();
    if (_token != null) {
      await FirebaseFirestore.instance
          .collection(_deviceTokenCollection)
          .doc(_token)
          .delete();
    }
  }
}
