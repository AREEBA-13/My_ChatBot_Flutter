// File configured to support dynamic manual configuration.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Your active Firebase project credentials have been automatically replicated
/// across all target platforms to ensure seamless execution on Windows, Android, iOS, and Web!
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCx7mFpLjDkSt7QfRK7xK2hF9NmIHylWR4',
    appId: '1:888167353343:web:101f4c3bd645019ca4b5ca',
    messagingSenderId: '888167353343',
    projectId: 'chatbot-696e8',
    authDomain: 'chatbot-696e8.firebaseapp.com',
    storageBucket: 'chatbot-696e8.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCx7mFpLjDkSt7QfRK7xK2hF9NmIHylWR4',
    appId: '1:888167353343:android:101f4c3bd645019ca4b5ca', // Adapted for Android
    messagingSenderId: '888167353343',
    projectId: 'chatbot-696e8',
    storageBucket: 'chatbot-696e8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCx7mFpLjDkSt7QfRK7xK2hF9NmIHylWR4',
    appId: '1:888167353343:ios:101f4c3bd645019ca4b5ca', // Adapted for iOS
    messagingSenderId: '888167353343',
    projectId: 'chatbot-696e8',
    storageBucket: 'chatbot-696e8.firebasestorage.app',
    iosBundleId: 'com.example.chat_bot',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCx7mFpLjDkSt7QfRK7xK2hF9NmIHylWR4',
    appId: '1:888167353343:ios:101f4c3bd645019ca4b5ca',
    messagingSenderId: '888167353343',
    projectId: 'chatbot-696e8',
    storageBucket: 'chatbot-696e8.firebasestorage.app',
    iosBundleId: 'com.example.chat_bot',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCx7mFpLjDkSt7QfRK7xK2hF9NmIHylWR4',
    appId: '1:888167353343:web:101f4c3bd645019ca4b5ca', // Uses web configuration fallback for Windows desktop
    messagingSenderId: '888167353343',
    projectId: 'chatbot-696e8',
    storageBucket: 'chatbot-696e8.firebasestorage.app',
  );
}
