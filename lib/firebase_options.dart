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
    apiKey: 'AIzaSyB6VVXagB2ld5ZyyS-KaSkS8NI1AWbLIFE',
    appId: '1:1091959777847:web:f077198d837907d94eedb2',
    messagingSenderId: '1091959777847',
    projectId: 'eco-collect-32195',
    authDomain: 'eco-collect-32195.firebaseapp.com',
    storageBucket: 'eco-collect-32195.appspot.com',
    measurementId: 'G-GE1LDCMTN5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBGAABlLjnPjVXmuR41efL30s9pM0bsUvo',
    appId: '1:1091959777847:android:8a3be850f8ac22424eedb2',
    messagingSenderId: '1091959777847',
    projectId: 'eco-collect-32195',
    storageBucket: 'eco-collect-32195.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAEdauIUSZA0-lFOE-eXqLh2PPXQnZi49c',
    appId: '1:1091959777847:ios:166691821546e38d4eedb2',
    messagingSenderId: '1091959777847',
    projectId: 'eco-collect-32195',
    storageBucket: 'eco-collect-32195.appspot.com',
    iosBundleId: 'com.kingrittik.ecoCollect',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAEdauIUSZA0-lFOE-eXqLh2PPXQnZi49c',
    appId: '1:1091959777847:ios:567bebbf587355394eedb2',
    messagingSenderId: '1091959777847',
    projectId: 'eco-collect-32195',
    storageBucket: 'eco-collect-32195.appspot.com',
    iosBundleId: 'com.kingrittik.ecoCollect.RunnerTests',
  );
}
