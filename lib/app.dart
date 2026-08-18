import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:driver_part/core/utility/snackbar_helper.dart';

import 'package:driver_part/l10n/app_localizations.dart';

import 'core/localization/app_locale_controller.dart';
import 'core/route/app_route.dart';
import 'core/theme/dart_theme.dart';
import 'core/theme/light_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final localeController = Get.find<AppLocaleController>();

        return Obx(
          () => GetMaterialApp(
            scaffoldMessengerKey: SnackbarHelper.scaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            title: AppLocalizations.of(context)?.appTitle ?? 'Car Parking',
            theme: lightThemeData(),
            darkTheme: darkThemeData(),
            themeMode: ThemeMode.light,
            initialRoute: AppRoute.splash,
            getPages: AppRoute.route,
            locale: localeController.currentLocale.value,
            fallbackLocale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
          ),
        );
      },
    );
  }
}
