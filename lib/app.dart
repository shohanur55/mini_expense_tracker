import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/binding/app_binding.dart';
import 'core/route/app_route.dart';
import 'core/service/auth_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/utility/app_constants.dart';
import 'core/utility/snackbar_helper.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final themeController = ThemeController.to;
        final authService = AuthService.to;

        return Obx(
          () => GetMaterialApp(
            scaffoldMessengerKey: SnackbarHelper.scaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.theme,
            initialBinding: AppBinding(),
            initialRoute: authService.isLoggedIn.value
                ? AppRoute.mainNav
                : AppRoute.login,
            getPages: AppRoute.route,
          ),
        );
      },
    );
  }
}
