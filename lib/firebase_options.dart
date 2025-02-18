// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBNHbhlf8nlQz23US7Wden-kJEcvIXB89I',
    appId: '1:242724995960:web:764f5db7e2f792b7877e8d',
    messagingSenderId: '242724995960',
    projectId: 'available-5b1f4',
    authDomain: 'available-5b1f4.firebaseapp.com',
    storageBucket: 'available-5b1f4.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-MREh4UiEShYc243OccmSe5zFMjy8_Vg',
    appId: '1:242724995960:android:9ce1480117f2c1df877e8d',
    messagingSenderId: '242724995960',
    projectId: 'available-5b1f4',
    storageBucket: 'available-5b1f4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQAwbhM-NADuZrlJNSWTueIvlheFCyvwk',
    appId: '1:242724995960:ios:35238f3b1609f752877e8d',
    messagingSenderId: '242724995960',
    projectId: 'available-5b1f4',
    storageBucket: 'available-5b1f4.firebasestorage.app',
    iosBundleId: 'co.akundadababalei.available',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDQAwbhM-NADuZrlJNSWTueIvlheFCyvwk',
    appId: '1:242724995960:ios:a19897c4939d0322877e8d',
    messagingSenderId: '242724995960',
    projectId: 'available-5b1f4',
    storageBucket: 'available-5b1f4.firebasestorage.app',
    iosBundleId: 'com.example.myApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBC3Sjsp258nGFbVmg8nql3szKWy4JUknQ',
    appId: '1:242724995960:web:1d4d417cace99f38877e8d',
    messagingSenderId: '242724995960',
    projectId: 'available-5b1f4',
    authDomain: 'available-5b1f4.firebaseapp.com',
    storageBucket: 'available-5b1f4.firebasestorage.app',
  );
}
