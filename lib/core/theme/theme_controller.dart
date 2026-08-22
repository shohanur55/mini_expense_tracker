import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../service/storage_service.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find<ThemeController>();
  final StorageService _storage = StorageService.to;

  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _storage.isDarkMode;
  }

  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storage.setIsDarkMode(isDarkMode.value);
    Get.changeThemeMode(theme);
  }
}
