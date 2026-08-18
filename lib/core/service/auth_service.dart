import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();
  final _storage = GetStorage();

  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _registeredUsersKey = 'registered_users';

  final RxnString currentUserEmail = RxnString();
  final RxnString currentUserName = RxnString();
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuthState();
  }

  void _checkAuthState() {
    final savedLoggedIn = _storage.read(_isLoggedInKey) ?? false;
    if (savedLoggedIn) {
      currentUserEmail.value = _storage.read(_userEmailKey);
      currentUserName.value = _storage.read(_userNameKey) ?? 'Expense Tracker User';
      isLoggedIn.value = true;
    } else {
      isLoggedIn.value = false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate async network call
    final users = _storage.read<Map<String, dynamic>>(_registeredUsersKey) ?? {};
    
    if (users.containsKey(email.toLowerCase())) {
      throw 'An account with this email already exists';
    }

    users[email.toLowerCase()] = {
      'email': email.trim(),
      'password': password,
      'name': name.trim(),
    };
    await _storage.write(_registeredUsersKey, users);

    // Automatically log in user after registration
    await _saveUserSession(email: email.trim(), name: name.trim());
    return true;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate async network call
    final users = _storage.read<Map<String, dynamic>>(_registeredUsersKey) ?? {};
    final userKey = email.trim().toLowerCase();

    if (!users.containsKey(userKey)) {
      // Default demo account auto-creation if testing first time
      if (email.contains('@')) {
        final defaultName = email.split('@').first;
        users[userKey] = {
          'email': email.trim(),
          'password': password,
          'name': defaultName[0].toUpperCase() + defaultName.substring(1),
        };
        await _storage.write(_registeredUsersKey, users);
      } else {
        throw 'No account found with this email';
      }
    }

    final userData = users[userKey] as Map<String, dynamic>;
    if (userData['password'] != password) {
      throw 'Invalid password. Please try again.';
    }

    await _saveUserSession(
      email: userData['email'] as String,
      name: (userData['name'] as String?) ?? 'Expense User',
    );
    return true;
  }

  Future<void> _saveUserSession({
    required String email,
    required String name,
  }) async {
    currentUserEmail.value = email;
    currentUserName.value = name;
    isLoggedIn.value = true;

    await _storage.write(_userEmailKey, email);
    await _storage.write(_userNameKey, name);
    await _storage.write(_isLoggedInKey, true);
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    currentUserEmail.value = null;
    currentUserName.value = null;
    isLoggedIn.value = false;

    await _storage.remove(_userEmailKey);
    await _storage.remove(_userNameKey);
    await _storage.write(_isLoggedInKey, false);
  }
}
