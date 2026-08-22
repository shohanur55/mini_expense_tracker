import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find<StorageService>();

  late final SharedPreferences _prefs;

  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserEmail = 'user_email';
  static const String keyUserName = 'user_name';
  static const String keyIsDarkMode = 'is_dark_mode';

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  bool get isLoggedIn => _prefs.getBool(keyIsLoggedIn) ?? false;
  Future<bool> setIsLoggedIn(bool value) async =>
      await _prefs.setBool(keyIsLoggedIn, value);

  String? get userEmail => _prefs.getString(keyUserEmail);
  Future<bool> setUserEmail(String? email) async {
    if (email == null) return await _prefs.remove(keyUserEmail);
    return await _prefs.setString(keyUserEmail, email);
  }

  String? get userName => _prefs.getString(keyUserName);
  Future<bool> setUserName(String? name) async {
    if (name == null) return await _prefs.remove(keyUserName);
    return await _prefs.setString(keyUserName, name);
  }

  Future<void> clearAuthData() async {
    await _prefs.remove(keyIsLoggedIn);
    await _prefs.remove(keyUserEmail);
    await _prefs.remove(keyUserName);
  }

  bool get isDarkMode => _prefs.getBool(keyIsDarkMode) ?? false;
  Future<bool> setIsDarkMode(bool value) async =>
      await _prefs.setBool(keyIsDarkMode, value);
}
