import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/global_widget/custom_button.dart';
import '../../../core/global_widget/custom_password_field.dart';
import '../../../core/global_widget/custom_text_field.dart';
import '../../../core/route/app_route.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/validation/form_validator.dart';
import '../controller/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Form(
              key: controller.loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo & Header
                  Container(
                    width: 72.w,
                    height: 72.w,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 38.r,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Sign in to track and manage your daily expenses',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 36.h),

                  // Email Field
                  CustomTextField(
                    label: 'Email Address',
                    hintText: 'name@example.com',
                    controller: controller.loginEmailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: FormValidation.validateEmail,
                  ),
                  SizedBox(height: 16.h),

                  // Password Field
                  CustomPasswordField(
                    label: 'Password',
                    hintText: 'Enter your password',
                    controller: controller.loginPasswordController,
                    validator: FormValidation.validatePassword,
                  ),
                  SizedBox(height: 28.h),

                  // Submit Button
                  Obx(
                    () => CustomButton(
                      text: 'Sign In',
                      isLoading: controller.isLoading.value,
                      onPressed: controller.login,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Navigation link to Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoute.register),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
