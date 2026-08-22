import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/global_widget/custom_button.dart';
import '../../../core/global_widget/custom_card.dart';
import '../../../core/global_widget/custom_dialog.dart';
import '../../../core/global_widget/empty_state_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utility/app_constants.dart';
import '../../../core/utility/date_formatter.dart';
import '../../dashboard/controller/main_view_controller.dart';
import '../../expense/controller/expense_controller.dart';
import '../../expense/model/expense_model.dart';

class HomeView extends GetView<ExpenseController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final recents = controller.recentExpenses;

          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: RefreshIndicator(
              onRefresh: controller.fetchExpenses,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dashboard',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              DateFormatter.formatMonthYear(DateTime.now()),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: AppColors.primary,
                            ),
                            onPressed: controller.openAddExpense,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        gradient: AppColors.headerGradient,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Expense',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                Icons.account_balance_wallet,
                                color: Colors.white.withValues(alpha: 0.9),
                                size: 24.r,
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            DateFormatter.formatCurrency(
                              controller.totalExpense,
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Divider(color: Colors.white.withValues(alpha: 0.2)),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Current Month's Expense:",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 13.sp,
                                ),
                              ),
                              Text(
                                DateFormatter.formatCurrency(
                                  controller.currentMonthExpense,
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Quick Action Add Expense Button
                    CustomButton(
                      text: 'Add New Expense',
                      icon: Icons.add_circle_outline,
                      onPressed: controller.openAddExpense,
                    ),
                    SizedBox(height: 28.h),

                    // Recent Expenses Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Expenses',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                          onPressed: () {
                            MainViewController.to.changeTab(
                              1,
                            ); // Go to Expense List tab
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // Recent Expenses List
                    if (recents.isEmpty)
                      EmptyStateWidget(
                        title: 'No Expenses Yet',
                        message:
                            'Tap "Add New Expense" to create your first entry!',
                        actionText: 'Add Expense',
                        onActionPressed: controller.openAddExpense,
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recents.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final expense = recents[index];
                          return _buildExpenseTile(context, expense, isDark);
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildExpenseTile(
    BuildContext context,
    ExpenseModel expense,
    bool isDark,
  ) {
    final catColor = AppColors.getCategoryColor(expense.category);
    final catIcon = AppConstants.getCategoryIcon(expense.category);

    return CustomCard(
      onTap: () => controller.openEditExpense(expense),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: catColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(catIcon, color: catColor, size: 24.r),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.category,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  expense.note ?? DateFormatter.formatShortDate(expense.date),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '-${DateFormatter.formatCurrency(expense.amount)}',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                DateFormatter.formatShortDate(expense.date),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, size: 20.r),
            onSelected: (value) {
              if (value == 'edit') {
                controller.openEditExpense(expense);
              } else if (value == 'delete') {
                CustomDialog.show(
                  title: 'Delete Expense',
                  message:
                      'Are you sure you want to delete this expense of ${DateFormatter.formatCurrency(expense.amount)}?',
                  confirmText: 'Delete',
                  confirmColor: AppColors.error,
                  onConfirm: () => controller.deleteExpense(expense),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
