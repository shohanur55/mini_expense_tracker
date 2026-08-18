import 'package:get/get.dart';
import '../service/auth_service.dart';
import '../service/expense_service.dart';
import '../theme/theme_controller.dart';
import '../../feature/auth/controller/auth_controller.dart';
import '../../feature/dashboard/controller/main_view_controller.dart';
import '../../feature/expense/controller/expense_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Feature Controllers
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<ExpenseController>(() => ExpenseController(), fenix: true);
    Get.lazyPut<MainViewController>(() => MainViewController(), fenix: true);
  }

  static void initCoreServices() {
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<ExpenseService>(ExpenseService(), permanent: true);
    Get.put<ThemeController>(ThemeController(), permanent: true);
  }
}
