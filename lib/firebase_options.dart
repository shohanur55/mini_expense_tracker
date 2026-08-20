import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDemoApiKeyForExpenseTrackerApp',
    appId: '1:1234567890:web:demoappkey',
    messagingSenderId: '1234567890',
    projectId: 'mini-expense-tracker-app',
    authDomain: 'mini-expense-tracker-app.firebaseapp.com',
    storageBucket: 'mini-expense-tracker-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDemoApiKeyForExpenseTrackerApp',
    appId: '1:1234567890:android:demoappkey',
    messagingSenderId: '1234567890',
    projectId: 'mini-expense-tracker-app',
    storageBucket: 'mini-expense-tracker-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDemoApiKeyForExpenseTrackerApp',
    appId: '1:1234567890:ios:demoappkey',
    messagingSenderId: '1234567890',
    projectId: 'mini-expense-tracker-app',
    storageBucket: 'mini-expense-tracker-app.appspot.com',
    iosBundleId: 'com.example.miniExpenseTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDemoApiKeyForExpenseTrackerApp',
    appId: '1:1234567890:ios:demoappkey',
    messagingSenderId: '1234567890',
    projectId: 'mini-expense-tracker-app',
    storageBucket: 'mini-expense-tracker-app.appspot.com',
    iosBundleId: 'com.example.miniExpenseTracker',
  );
}
