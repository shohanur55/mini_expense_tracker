import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/global_widget/custom_button.dart';
import '../../../core/global_widget/custom_password_field.dart';
import '../../../core/global_widget/custom_text_field.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/validation/form_validator.dart';
import '../controller/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Form(
                key: controller.regFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Join Mini Expense Tracker to manage your money smartly',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Email Address
                    CustomTextField(
                      label: 'Email Address',
                      hintText: 'name@example.com',
                      controller: controller.regEmailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: FormValidation.validateEmail,
                    ),
                    SizedBox(height: 16.h),

                    // Password
                    CustomPasswordField(
                      label: 'Password',
                      hintText: 'Create a password (min 6 chars)',
                      controller: controller.regPasswordController,
                      validator: FormValidation.validatePassword,
                    ),
                    SizedBox(height: 28.h),

                    // Register Button
                    Obx(
                      () => CustomButton(
                        text: 'Register Account',
                        isLoading: controller.isLoading.value,
                        onPressed: controller.register,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Sign in link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Text(
                            'Sign In',
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
      ),
    );
  }
}
