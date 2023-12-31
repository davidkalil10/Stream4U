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
    apiKey: 'AIzaSyBa1wGFAxiO7jh_WVIADTjjVLrEdjBdqBc',
    appId: '1:1069059115965:web:5c0b7da88f5b7e973760d4',
    messagingSenderId: '1069059115965',
    projectId: 'stream4u-5658b',
    authDomain: 'stream4u-5658b.firebaseapp.com',
    storageBucket: 'stream4u-5658b.appspot.com',
    measurementId: 'G-1C861CYB2K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNSNW0A_1Eqn4v7HTczQjXn0Rcld56V_M',
    appId: '1:1069059115965:android:c7997352c046d85d3760d4',
    messagingSenderId: '1069059115965',
    projectId: 'stream4u-5658b',
    storageBucket: 'stream4u-5658b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAYioUibP9F1Bf92o3y0i-FAu88ydbo2m8',
    appId: '1:1069059115965:ios:d9523c1a928b7ba23760d4',
    messagingSenderId: '1069059115965',
    projectId: 'stream4u-5658b',
    storageBucket: 'stream4u-5658b.appspot.com',
    iosBundleId: 'com.xXFalcoonXx.com.stream4u',
  );
}
