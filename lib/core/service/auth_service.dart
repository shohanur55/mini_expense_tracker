import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();

  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _isLoggedInKey = 'is_logged_in';

  final Rxn<User> firebaseUser = Rxn<User>();
  final RxnString currentUserEmail = RxnString();
  final RxnString currentUserName = RxnString();
  final RxBool isLoggedIn = false.obs;

  String get currentUserId => firebaseUser.value?.uid ?? currentUserEmail.value ?? '';

  @override
  void onInit() {
    super.onInit();
    _initAuthState();
  }

  void _initAuthState() {
    // Bind Firebase auth state changes to reactive user object
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthChanged);

    // Initial local cache check for offline speed
    final savedLoggedIn = _storage.read<bool>(_isLoggedInKey) ?? false;
    if (savedLoggedIn && _auth.currentUser == null) {
      currentUserEmail.value = _storage.read<String>(_userEmailKey);
      currentUserName.value = _storage.read<String>(_userNameKey) ?? 'Expense Tracker User';
      isLoggedIn.value = true;
    }
  }

  Future<void> _handleAuthChanged(User? user) async {
    if (user != null) {
      currentUserEmail.value = user.email;
      isLoggedIn.value = true;
      
      final displayName = user.displayName?.trim().isNotEmpty == true
          ? user.displayName!.trim()
          : (user.email?.split('@').first ?? 'Expense User');
      
      currentUserName.value = displayName;

      await _storage.write(_userEmailKey, user.email);
      await _storage.write(_userNameKey, displayName);
      await _storage.write(_isLoggedInKey, true);

      // Fetch Firestore user doc for updated profile info if present
      _fetchFirestoreUserProfile(user.uid);
    } else {
      currentUserEmail.value = null;
      currentUserName.value = null;
      isLoggedIn.value = false;

      await _storage.remove(_userEmailKey);
      await _storage.remove(_userNameKey);
      await _storage.write(_isLoggedInKey, false);
    }
  }

  Future<void> _fetchFirestoreUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data.containsKey('name') && (data['name'] as String).isNotEmpty) {
          currentUserName.value = data['name'] as String;
          await _storage.write(_userNameKey, data['name']);
        }
      }
    } catch (_) {
      // Ignore network failure on background profile fetch
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final displayName = name?.trim().isNotEmpty == true
          ? name!.trim()
          : email.trim().split('@').first;

      if (credential.user != null) {
        await credential.user!.updateDisplayName(displayName);

        // Store user document in Firestore 'users' collection
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'email': email.trim(),
          'name': displayName,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      currentUserEmail.value = email.trim();
      currentUserName.value = displayName;
      isLoggedIn.value = true;

      await _storage.write(_userEmailKey, email.trim());
      await _storage.write(_userNameKey, displayName);
      await _storage.write(_isLoggedInKey, true);

      return true;
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        final name = user.displayName?.isNotEmpty == true
            ? user.displayName!
            : email.split('@').first;
        
        currentUserEmail.value = user.email;
        currentUserName.value = name;
        isLoggedIn.value = true;

        await _storage.write(_userEmailKey, user.email);
        await _storage.write(_userNameKey, name);
        await _storage.write(_isLoggedInKey, true);
        
        _fetchFirestoreUserProfile(user.uid);
      }
      return true;
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (_) {}
    currentUserEmail.value = null;
    currentUserName.value = null;
    isLoggedIn.value = false;

    await _storage.remove(_userEmailKey);
    await _storage.remove(_userNameKey);
    await _storage.write(_isLoggedInKey, false);
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      default:
        return e.message ?? 'Authentication failed. Please check your network and credentials.';
    }
  }
}
