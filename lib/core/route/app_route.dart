import 'package:get/get.dart';
import '../../feature/auth/view/login_view.dart';
import '../../feature/auth/view/register_view.dart';
import '../../feature/dashboard/view/main_nav_view.dart';
import '../../feature/expense/view/add_edit_expense_view.dart';

class AppRoute {
  static const String login = '/login';
  static const String register = '/register';
  static const String mainNav = '/mainNav';
  static const String addExpense = '/addExpense';
  static const String editExpense = '/editExpense';

  static final route = [
    GetPage(
      name: login,
      page: () => const LoginView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: register,
      page: () => const RegisterView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: mainNav,
      page: () => const MainNavView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: addExpense,
      page: () => const AddEditExpenseView(isEditing: false),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: editExpense,
      page: () => const AddEditExpenseView(isEditing: true),
      transition: Transition.downToUp,
    ),
  ];
}
