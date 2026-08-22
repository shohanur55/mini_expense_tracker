import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_WEB_API_KEY'] ?? 'AIzaSyA8ocs1MeNQFO9LMCbFckimN8pQNnIT-v0',
    appId: '1:485456853445:web:3bcf7d37331343d2ab73ac',
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '485456853445',
    projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'mini-expense-tracker-60cb9',
    authDomain: 'mini-expense-tracker-60cb9.firebaseapp.com',
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'mini-expense-tracker-60cb9.firebasestorage.app',
    measurementId: 'G-P0HQW1JW1F',
  );

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_ANDROID_API_KEY'] ?? 'AIzaSyDgy_bZKZQsIl1mMmE3igME2cw3Hd2FdS0',
    appId: '1:485456853445:android:d918e21ffdbba19aab73ac',
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '485456853445',
    projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'mini-expense-tracker-60cb9',
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'mini-expense-tracker-60cb9.firebasestorage.app',
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_IOS_API_KEY'] ?? 'AIzaSyDhezjY6c3sMv-4wMcj5G_Ym-HcxS_4aUA',
    appId: '1:485456853445:ios:bf796435109345e2ab73ac',
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '485456853445',
    projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'mini-expense-tracker-60cb9',
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'mini-expense-tracker-60cb9.firebasestorage.app',
    iosBundleId: 'com.example.miniExpenseTracker',
  );

  static FirebaseOptions get macos => FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_IOS_API_KEY'] ?? 'AIzaSyDhezjY6c3sMv-4wMcj5G_Ym-HcxS_4aUA',
    appId: '1:485456853445:ios:bf796435109345e2ab73ac',
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '485456853445',
    projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'mini-expense-tracker-60cb9',
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'mini-expense-tracker-60cb9.firebasestorage.app',
    iosBundleId: 'com.example.miniExpenseTracker',
  );

  static FirebaseOptions get windows => FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_WEB_API_KEY'] ?? 'AIzaSyA8ocs1MeNQFO9LMCbFckimN8pQNnIT-v0',
    appId: '1:485456853445:web:8342cfbaee931f53ab73ac',
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '485456853445',
    projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'mini-expense-tracker-60cb9',
    authDomain: 'mini-expense-tracker-60cb9.firebaseapp.com',
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'mini-expense-tracker-60cb9.firebasestorage.app',
    measurementId: 'G-MVM05N3VCY',
  );
}
