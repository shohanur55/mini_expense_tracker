import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/route/app_route.dart';
import '../../../core/service/auth_service.dart';
import '../../../core/utility/snackbar_helper.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();
  final AuthService _authService = AuthService.to;

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  final regNameController = TextEditingController();
  final regEmailController = TextEditingController();
  final regPasswordController = TextEditingController();
  final regFormKey = GlobalKey<FormState>();

  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    regNameController.dispose();
    regEmailController.dispose();
    regPasswordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await _authService.login(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text,
      );
      SnackbarHelper.showSuccess('Welcome back!', 'Logged in successfully');
      loginEmailController.clear();
      loginPasswordController.clear();
      Get.offAllNamed(AppRoute.mainNav);
    } catch (e) {
      SnackbarHelper.showError('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!regFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await _authService.register(
        name: regNameController.text.trim(),
        email: regEmailController.text.trim(),
        password: regPasswordController.text,
      );
      SnackbarHelper.showSuccess('Account Created!', 'Welcome to Mini Expense Tracker');
      regNameController.clear();
      regEmailController.clear();
      regPasswordController.clear();
      Get.offAllNamed(AppRoute.mainNav);
    } catch (e) {
      SnackbarHelper.showError('Registration Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(AppRoute.login);
    SnackbarHelper.showInfo('Logged Out', 'You have been logged out successfully');
  }
}
