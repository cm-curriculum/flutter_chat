// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyArnhV3l0Jn2iX796GTF6ri83UEhNCvqZ8',
    appId: '1:532688473211:web:0fb68903f6f73e6193e6de',
    messagingSenderId: '532688473211',
    projectId: 'chattest-c27ba',
    authDomain: 'chattest-c27ba.firebaseapp.com',
    storageBucket: 'chattest-c27ba.appspot.com',
    measurementId: 'G-N37YY95ENK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBm6JWp-Eo7wKv5xuzgaUOaHdxFyxXJ_54',
    appId: '1:532688473211:android:a1dfb264795d2de393e6de',
    messagingSenderId: '532688473211',
    projectId: 'chattest-c27ba',
    storageBucket: 'chattest-c27ba.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA0CQe-O1rYINzONX2AUVG93o6eS3ZaXgg',
    appId: '1:532688473211:ios:2de2ad005223aaf393e6de',
    messagingSenderId: '532688473211',
    projectId: 'chattest-c27ba',
    storageBucket: 'chattest-c27ba.appspot.com',
    iosBundleId: 'com.example.chatTest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA0CQe-O1rYINzONX2AUVG93o6eS3ZaXgg',
    appId: '1:532688473211:ios:79f57d876f8da94b93e6de',
    messagingSenderId: '532688473211',
    projectId: 'chattest-c27ba',
    storageBucket: 'chattest-c27ba.appspot.com',
    iosBundleId: 'com.example.chatTest.RunnerTests',
  );
}
