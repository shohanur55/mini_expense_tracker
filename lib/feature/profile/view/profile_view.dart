import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/global_widget/custom_button.dart';
import '../../../core/global_widget/custom_card.dart';
import '../../../core/global_widget/custom_dialog.dart';
import '../../../core/service/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/utility/date_formatter.dart';
import '../../auth/controller/auth_controller.dart';
import '../../expense/controller/expense_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authService = AuthService.to;
    final themeController = ThemeController.to;
    final expenseController = ExpenseController.to;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            children: [
              // User Avatar & Info Card
              CustomCard(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 38.r,
                      backgroundColor: AppColors.primarySoft,
                      child: Icon(
                        Icons.person,
                        size: 42.r,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Obx(
                      () => Text(
                        authService.currentUserName.value ?? 'User Account',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Obx(
                      () => Text(
                        authService.currentUserEmail.value ?? 'user@example.com',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Spending Statistics Card
              CustomCard(
                padding: EdgeInsets.all(16.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Total Expenses',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        SizedBox(height: 4.h),
                        Obx(
                          () => Text(
                            DateFormatter.formatCurrency(
                                expenseController.totalExpense),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 36.h,
                      width: 1,
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                    Column(
                      children: [
                        Text(
                          'Entries Count',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        SizedBox(height: 4.h),
                        Obx(
                          () => Text(
                            '${expenseController.expenses.length}',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Settings & Theme Toggle
              CustomCard(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  children: [
                    Obx(
                      () => SwitchListTile(
                        value: themeController.isDarkMode.value,
                        onChanged: (val) => themeController.toggleTheme(),
                        title: const Text('Dark Mode'),
                        subtitle: const Text('Toggle app appearance theme'),
                        secondary: Icon(
                          themeController.isDarkMode.value
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              // Logout Button
              CustomButton(
                text: 'Log Out',
                icon: Icons.logout,
                type: ButtonType.outline,
                onPressed: () {
                  CustomDialog.show(
                    title: 'Log Out',
                    message: 'Are you sure you want to log out of your account?',
                    confirmText: 'Log Out',
                    confirmColor: AppColors.error,
                    onConfirm: () => AuthController.to.logout(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
