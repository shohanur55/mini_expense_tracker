import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'core/binding/app_binding.dart';
import 'core/service/storage_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('dotenv loading warning: $e');
  }

  // Initialize Firebase Core
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization warning: $e');
  }

  // Initialize Storage Service (SharedPreferences)
  await Get.putAsync(() => StorageService().init());

  // Initialize core app services (Auth, Service, Theme)
  AppBinding.initCoreServices();

  runApp(const MyApp());
}
