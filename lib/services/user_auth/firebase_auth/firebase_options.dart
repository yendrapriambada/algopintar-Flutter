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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBCrL8knbWgiIyBLbpZE3RPlEyhMuNKl98',
    appId: '1:828960463204:web:31b693baf350a4a4068271',
    messagingSenderId: '828960463204',
    projectId: 'algo-pintar-da344',
    authDomain: 'algo-pintar-da344.firebaseapp.com',
    databaseURL: 'https://algo-pintar-da344-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'algo-pintar-da344.appspot.com',
    measurementId: 'G-15TGT4QM6F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDMLdi3Iq-nXhky2eFwDwIE7oy30K1MfLo',
    appId: '1:828960463204:android:00c6e29b436b4e53068271',
    messagingSenderId: '828960463204',
    projectId: 'algo-pintar-da344',
    databaseURL: 'https://algo-pintar-da344-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'algo-pintar-da344.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCmfRRyIm93kjV9OAHPkMrHsXQQIWqudi4',
    appId: '1:828960463204:ios:7c0f38d50842d8ce068271',
    messagingSenderId: '828960463204',
    projectId: 'algo-pintar-da344',
    databaseURL: 'https://algo-pintar-da344-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'algo-pintar-da344.appspot.com',
    iosBundleId: 'com.yendrastudio.algopintar.algopintar',
  );
}
