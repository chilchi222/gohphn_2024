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
    apiKey: 'AIzaSyCMTYAjkwrAfAG18W-9UYr4O8RYn_GHcPQ',
    appId: '1:1518433467:web:666184e1a858ab6824a59e',
    messagingSenderId: '1518433467',
    projectId: 'gohphn-test',
    authDomain: 'gohphn-test.firebaseapp.com',
    databaseURL: 'https://gohphn-test-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'gohphn-test.appspot.com',
    measurementId: 'G-FL0D6HM8GF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQmYbUsAvVh1n3_PZk87OWRoHRl5DaO7s',
    appId: '1:1518433467:android:f720e7e7911308b524a59e',
    messagingSenderId: '1518433467',
    projectId: 'gohphn-test',
    databaseURL: 'https://gohphn-test-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'gohphn-test.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBVr400ZLrls_sQkn8GhNWwlMRvV0JMe_c',
    appId: '1:1518433467:ios:569934f9fdde87e124a59e',
    messagingSenderId: '1518433467',
    projectId: 'gohphn-test',
    databaseURL: 'https://gohphn-test-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'gohphn-test.appspot.com',
    androidClientId: '1518433467-l2eetob14e7uplprhs7f8jkut6bhb38s.apps.googleusercontent.com',
    iosBundleId: 'com.example.gohphn2024',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBVr400ZLrls_sQkn8GhNWwlMRvV0JMe_c',
    appId: '1:1518433467:ios:58725b41585abc2524a59e',
    messagingSenderId: '1518433467',
    projectId: 'gohphn-test',
    databaseURL: 'https://gohphn-test-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'gohphn-test.appspot.com',
    androidClientId: '1518433467-l2eetob14e7uplprhs7f8jkut6bhb38s.apps.googleusercontent.com',
    iosBundleId: 'com.example.gohphn2024.RunnerTests',
  );
}
