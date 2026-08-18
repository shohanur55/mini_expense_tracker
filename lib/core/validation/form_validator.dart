
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../l10n/app_localizations.dart';

class FormValidation {
  static AppLocalizations? get _l10n {
    final context = Get.context;
    return context == null ? null : AppLocalizations.of(context);
  }

static String formatDate(String dateTimeString) {
  try {
    DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
    String day = DateFormat('dd').format(dateTime);
    String month = DateFormat('MMM').format(dateTime);
    String time = DateFormat('hh:mm a').format(dateTime);

    return '$day $month • $time';
  } catch (e) {
    return _l10n?.invalidDate ?? 'Invalid Date';
  }
}
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return _l10n?.emailCannotBeEmpty ?? "Email can't be empty";
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return _l10n?.validEmail ?? "Please enter a valid email";
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return _l10n?.phoneCannotBeEmpty ?? 'Phone number cannot be empty';
    }

    // Phone number regex (accepts 10-15 digit numbers, with optional '+' at the beginning)
    const phonePattern = r'^\+?[0-9]{10,15}$';
    final regex = RegExp(phonePattern);

    if (!regex.hasMatch(value.trim())) {
      return _l10n?.validPhone ?? 'Enter a valid phone number';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return _l10n?.passwordCannotBeEmpty ?? "Password can't be empty";
    }
    if (value.length < 6) {
      return _l10n?.passwordMinLength ?? "Password must be at least 6 characters";
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return _l10n?.passwordUppercase ?? "Password must contain at least one uppercase letter";
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return _l10n?.passwordLowercase ?? "Password must contain at least one lowercase letter";
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return _l10n?.passwordNumber ?? "Password must contain at least one number";
    }
    return null;
  }

  static  String? validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return _l10n?.pinCannotBeEmpty ?? 'PIN cannot be empty';
    }
    if (value.length != 6) {
      return _l10n?.pinExactly6 ?? 'PIN must be exactly 6 digits';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return _l10n?.pinOnlyNumbers ?? 'PIN must contain only numbers';
    }
    return null;
  }

  static String? validateName(String? name) {
    if (name!.trim().isEmpty) {
      return _l10n?.nameCannotBeEmpty ?? "Name cannot be empty";
    }
    return null; // Indicates the name is valid
  }
  static String? validateAddress(String? name) {
    if (name!.trim().isEmpty) {
      return _l10n?.nameCannotBeEmpty ?? "Name cannot be empty";
    }
    return null; // Indicates the name is valid
  }
}