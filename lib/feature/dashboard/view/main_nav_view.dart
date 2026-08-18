import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../expense/view/expense_chart_view.dart';
import '../../expense/view/expense_list_view.dart';
import '../../home/view/home_view.dart';
import '../../profile/view/profile_view.dart';
import '../controller/main_view_controller.dart';

class MainNavView extends GetView<MainViewController> {
  const MainNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> pages = const [
      HomeView(),
      ExpenseListView(),
      ExpenseChartView(),
      ProfileView(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changeTab,
          backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
          elevation: 8,
          indicatorColor: AppColors.primarySoft,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long, color: AppColors.primary),
              label: 'Expenses',
            ),
            NavigationDestination(
              icon: Icon(Icons.pie_chart_outline),
              selectedIcon: Icon(Icons.pie_chart, color: AppColors.primary),
              label: 'Analytics',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: AppColors.primary),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
