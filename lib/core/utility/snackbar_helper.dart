import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static Future<void> show(
    String title,
    String message, {
    Color? backgroundColor,
    Color? colorText,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
    Duration duration = const Duration(seconds: 3),
  }) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final messenger = scaffoldMessengerKey.currentState;
        final context = scaffoldMessengerKey.currentContext ?? Get.context;

        if (messenger != null) {
          try {
            messenger.hideCurrentSnackBar();
          } catch (_) {}

          final mediaQuery =
              context != null ? MediaQuery.maybeOf(context) : null;
          final topInset = (mediaQuery?.padding.top ?? 12) + 12;

          messenger.showSnackBar(
            SnackBar(
              content: Text(
                title.trim().isEmpty ? message : '$title\n$message',
                style: TextStyle(color: colorText),
              ),
              backgroundColor: backgroundColor,
              duration: duration,
              behavior: SnackBarBehavior.floating,
              margin:
                  snackPosition == SnackPosition.TOP
                      ? EdgeInsets.fromLTRB(12, topInset, 12, 12)
                      : const EdgeInsets.all(12),
            ),
          );
          return;
        }

        if (context != null) {
          final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
          if (scaffoldMessenger != null) {
            try {
              scaffoldMessenger.hideCurrentSnackBar();
            } catch (_) {}

            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(
                  title.trim().isEmpty ? message : '$title\n$message',
                  style: TextStyle(color: colorText),
                ),
                backgroundColor: backgroundColor,
                duration: duration,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(12),
              ),
            );
            return;
          }
        }

        try {
          if (Get.isSnackbarOpen) {
            Get.closeCurrentSnackbar();
          }
          Get.snackbar(
            title,
            message,
            backgroundColor: backgroundColor,
            colorText: colorText,
            snackPosition: SnackPosition.TOP,
            duration: duration,
          );
        } catch (e) {
          debugPrint('SnackbarHelper fallback error: $e');
        }
      } catch (e) {
        debugPrint('SnackbarHelper error: $e');
      }
    });
  }
}
