import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
import 'core/binding/app_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize persistent local storage
  await GetStorage.init();

  // Initialize core app services (Auth, Storage, Theme)
  AppBinding.initCoreServices();

  runApp(const MyApp());
}
