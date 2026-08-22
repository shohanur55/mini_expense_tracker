import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/route/app_route.dart';
import '../../../core/service/auth_service.dart';
import '../../../core/utility/snackbar_helper.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();
  final AuthService _authService = AuthService.to;

  late TextEditingController loginEmailController;
  late TextEditingController loginPasswordController;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  late TextEditingController regNameController;
  late TextEditingController regEmailController;
  late TextEditingController regPasswordController;
  GlobalKey<FormState> regFormKey = GlobalKey<FormState>();

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    resetLoginForm();
    resetRegForm();
  }

  void resetLoginForm() {
    loginEmailController = TextEditingController();
    loginPasswordController = TextEditingController();
    loginFormKey = GlobalKey<FormState>();
  }

  void resetRegForm() {
    regNameController = TextEditingController();
    regEmailController = TextEditingController();
    regPasswordController = TextEditingController();
    regFormKey = GlobalKey<FormState>();
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    try {
      await _authService.login(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text,
      );
      SnackbarHelper.showSuccess('Welcome Back!', 'Logged in successfully');
      resetLoginForm();
      Get.offAllNamed(AppRoute.mainNav);
    } catch (e) {
      SnackbarHelper.showError('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!regFormKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    try {
      await _authService.register(
        email: regEmailController.text.trim(),
        password: regPasswordController.text,
        name: regNameController.text.trim(),
      );
      SnackbarHelper.showSuccess('Account Created!', 'Welcome to Mini Expense Tracker');
      resetRegForm();
      Get.offAllNamed(AppRoute.mainNav);
    } catch (e) {
      SnackbarHelper.showError('Registration Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    FocusManager.instance.primaryFocus?.unfocus();
    resetLoginForm();
    resetRegForm();
    await _authService.logout();
    Get.offAllNamed(AppRoute.login);
    SnackbarHelper.showInfo('Logged Out', 'You have been logged out successfully');
  }
}
