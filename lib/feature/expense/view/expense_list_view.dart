import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/global_widget/custom_card.dart';
import '../../../core/global_widget/custom_dialog.dart';
import '../../../core/global_widget/custom_text_field.dart';
import '../../../core/global_widget/empty_state_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utility/app_constants.dart';
import '../../../core/utility/date_formatter.dart';
import '../controller/expense_controller.dart';
import '../model/expense_model.dart';

class ExpenseListView extends GetView<ExpenseController> {
  const ExpenseListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoriesFilterList = ['All', ...AppConstants.categories];

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: controller.openAddExpense,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input Field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: CustomTextField(
                hintText: 'Search by category or note...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => controller.searchQuery.value = '',
                      )
                    : const SizedBox.shrink()),
                onTap: null,
                controller: TextEditingController(text: controller.searchQuery.value)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.searchQuery.value.length),
                  ),
              ),
            ),

            // Horizontal Category Filter Chips
            SizedBox(
              height: 44.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: categoriesFilterList.length,
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  final cat = categoriesFilterList[index];
                  return Obx(() {
                    final isSelected =
                        controller.selectedCategoryFilter.value == cat;
                    return FilterChip(
                      selected: isSelected,
                      label: Text(cat),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary),
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 13.sp,
                      ),
                      backgroundColor:
                          isDark ? AppColors.darkCard : AppColors.lightSurface,
                      selectedColor: AppColors.primary,
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder),
                        ),
                      ),
                      onSelected: (selected) {
                        controller.selectedCategoryFilter.value = cat;
                      },
                    );
                  });
                },
              ),
            ),
            SizedBox(height: 12.h),

            // Expense List Body
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filtered = controller.filteredExpenses;

                if (filtered.isEmpty) {
                  return EmptyStateWidget(
                    title: 'No Expenses Found',
                    message: controller.searchQuery.value.isNotEmpty ||
                            controller.selectedCategoryFilter.value != 'All'
                        ? 'No expenses match your search or filter criteria.'
                        : 'You haven\'t added any expenses yet.',
                    actionText: 'Add Expense',
                    onActionPressed: controller.openAddExpense,
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchExpenses,
                  child: ListView.separated(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final expense = filtered[index];
                      return _buildExpenseTile(context, expense, isDark);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.openAddExpense,
        tooltip: 'Add Expense',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildExpenseTile(
      BuildContext context, ExpenseModel expense, bool isDark) {
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
