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
    apiKey: 'AIzaSyC0fx5sLnF-BRQowXUmjPax_GGyDQuezHw',
    appId: '1:807087449057:web:2ca88ea050a4685d3de8a0',
    messagingSenderId: '807087449057',
    projectId: 'chat-app-97b4e',
    authDomain: 'chat-app-97b4e.firebaseapp.com',
    storageBucket: 'chat-app-97b4e.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnPVPgfuL2Ne5ZA2drDoDEXrdZ-hiOiwU',
    appId: '1:807087449057:android:c4c11d48e83cd0c53de8a0',
    messagingSenderId: '807087449057',
    projectId: 'chat-app-97b4e',
    storageBucket: 'chat-app-97b4e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCxebXBZGp8ivKAOo9z3FL5xpCOYHckCXg',
    appId: '1:807087449057:ios:4539f57ae4341fdc3de8a0',
    messagingSenderId: '807087449057',
    projectId: 'chat-app-97b4e',
    storageBucket: 'chat-app-97b4e.firebasestorage.app',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCxebXBZGp8ivKAOo9z3FL5xpCOYHckCXg',
    appId: '1:807087449057:ios:4539f57ae4341fdc3de8a0',
    messagingSenderId: '807087449057',
    projectId: 'chat-app-97b4e',
    storageBucket: 'chat-app-97b4e.firebasestorage.app',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC0fx5sLnF-BRQowXUmjPax_GGyDQuezHw',
    appId: '1:807087449057:web:6cb7d50b18dafe103de8a0',
    messagingSenderId: '807087449057',
    projectId: 'chat-app-97b4e',
    authDomain: 'chat-app-97b4e.firebaseapp.com',
    storageBucket: 'chat-app-97b4e.firebasestorage.app',
  );
}
