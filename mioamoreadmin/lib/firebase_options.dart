import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAIHfHW9-oYEKo5xbS0bCVNnDZDwEuKYbM',
    appId: '1:486621646434:android:cd45d002fe7a7d5551cb3b',
    messagingSenderId: '486621646434',
    projectId: 'socialworkexam-2db1b',
    storageBucket: 'socialworkexam-2db1b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB0-0K6TlZ0afiXaS462dq-slWHyE4-9AY',
    appId: '1:486621646434:ios:e59e4eaa9978877551cb3b',
    messagingSenderId: '486621646434',
    projectId: 'socialworkexam-2db1b',
    storageBucket: 'socialworkexam-2db1b.appspot.com',
    iosBundleId: 'com.allied.socialworkexam',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyALbL1NGRVSXaPoBLsOuexotNH1WlB9U88",
    authDomain: "datingapp-3bf97.firebaseapp.com",
    projectId: "datingapp-3bf97",
    storageBucket: "datingapp-3bf97.firebasestorage.app",
    messagingSenderId: "28416760775",
    appId: "1:28416760775:web:1bfc6b22f7a97e6456d7e2",
  );
}
