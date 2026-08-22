import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storage = StorageService.to;

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
    // Initial local cache check from SharedPreferences
    if (_storage.isLoggedIn) {
      currentUserEmail.value = _storage.userEmail;
      currentUserName.value = _storage.userName ?? 'Expense User';
      isLoggedIn.value = true;
    }

    // Bind Firebase auth state changes to reactive user object
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthChanged);
  }

  Future<void> _handleAuthChanged(User? user) async {
    if (user != null) {
      currentUserEmail.value = user.email;
      isLoggedIn.value = true;
      
      final displayName = user.displayName?.trim().isNotEmpty == true
          ? user.displayName!.trim()
          : (user.email?.split('@').first ?? 'Expense User');
      
      currentUserName.value = displayName;

      await _storage.setIsLoggedIn(true);
      await _storage.setUserEmail(user.email);
      await _storage.setUserName(displayName);

      // Fetch Firestore user doc for updated profile info if present
      _fetchFirestoreUserProfile(user.uid);
    } else {
      currentUserEmail.value = null;
      currentUserName.value = null;
      isLoggedIn.value = false;

      await _storage.clearAuthData();
    }
  }

  Future<void> _fetchFirestoreUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data.containsKey('name') && (data['name'] as String).isNotEmpty) {
          currentUserName.value = data['name'] as String;
          await _storage.setUserName(data['name'] as String);
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

      await _storage.setIsLoggedIn(true);
      await _storage.setUserEmail(email.trim());
      await _storage.setUserName(displayName);

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

        await _storage.setIsLoggedIn(true);
        await _storage.setUserEmail(user.email);
        await _storage.setUserName(name);
        
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

    await _storage.clearAuthData();
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
