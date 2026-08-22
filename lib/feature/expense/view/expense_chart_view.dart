import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/global_widget/custom_card.dart';
import '../../../core/global_widget/empty_state_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utility/app_constants.dart';
import '../../../core/utility/date_formatter.dart';
import '../controller/expense_controller.dart';

class ExpenseChartView extends GetView<ExpenseController> {
  const ExpenseChartView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Analytics'),
      ),
      body: SafeArea(
        child: Obx(() {
          final breakdown = controller.categoryBreakdown;
          final total = controller.totalExpense;

          if (controller.expenses.isEmpty || total == 0) {
            return const EmptyStateWidget(
              title: 'No Data for Analytics',
              message: 'Add some expenses to see category breakdown charts.',
            );
          }

          final categories = breakdown.keys.toList();

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spending by Category',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 20.h),

                    // Pie Chart Card
                    CustomCard(
                      padding: EdgeInsets.all(20.r),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200.h,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 3,
                                centerSpaceRadius: 40.r,
                                sections: categories.map((cat) {
                                  final catAmount = breakdown[cat]!;
                                  final percentage = (catAmount / total) * 100;
                                  final color = AppColors.getCategoryColor(cat);
                                  return PieChartSectionData(
                                    color: color,
                                    value: catAmount,
                                    title: '${percentage.toStringAsFixed(0)}%',
                                    radius: 55.r,
                                    titleStyle: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Total Spent: ${DateFormatter.formatCurrency(total)}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Category List Breakdown
                    Text(
                      'Category Breakdown',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 12.h),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      separatorBuilder: (context, index) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final catAmount = breakdown[cat]!;
                        final percentage = (catAmount / total) * 100;
                        final color = AppColors.getCategoryColor(cat);
                        final icon = AppConstants.getCategoryIcon(cat);

                        return CustomCard(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.r),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(icon, color: color, size: 22.r),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cat,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontSize: 15.sp),
                                    ),
                                    SizedBox(height: 2.h),
                                    LinearProgressIndicator(
                                      value: percentage / 100,
                                      backgroundColor: isDark
                                          ? AppColors.darkBorder
                                          : AppColors.lightBorder,
                                      color: color,
                                      minHeight: 4.h,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    DateFormatter.formatCurrency(catAmount),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  Text(
                                    '${percentage.toStringAsFixed(1)}%',
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
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
}
