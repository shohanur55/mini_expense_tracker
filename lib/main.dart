import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
import 'core/binding/app_binding.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase Core
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization warning: $e');
  }

  // Initialize persistent local storage
  await GetStorage.init();

  // Initialize core app services (Auth, Storage, Theme)
  AppBinding.initCoreServices();

  runApp(const MyApp());
}
