import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_expense_tracker/core/service/storage_service.dart';
import 'package:mini_expense_tracker/core/utility/app_constants.dart';
import 'package:mini_expense_tracker/core/utility/date_formatter.dart';
import 'package:mini_expense_tracker/core/validation/form_validator.dart';
import 'package:mini_expense_tracker/feature/expense/model/expense_model.dart';

void main() {
  group('FormValidation Tests', () {
    test('validateEmail returns null for valid email', () {
      expect(FormValidation.validateEmail('user@example.com'), isNull);
    });

    test('validateEmail returns error for invalid email', () {
      expect(FormValidation.validateEmail('invalid-email'), isNotNull);
      expect(FormValidation.validateEmail(''), isNotNull);
    });

    test('validatePassword returns null for valid password', () {
      expect(FormValidation.validatePassword('123456'), isNull);
    });

    test('validatePassword returns error for short password', () {
      expect(FormValidation.validatePassword('123'), isNotNull);
    });

    test('validateAmount returns null for positive numbers', () {
      expect(FormValidation.validateAmount('45.50'), isNull);
    });

    test('validateAmount returns error for zero or negative numbers', () {
      expect(FormValidation.validateAmount('0'), isNotNull);
      expect(FormValidation.validateAmount('-10'), isNotNull);
      expect(FormValidation.validateAmount('abc'), isNotNull);
    });
  });

  group('ExpenseModel Tests', () {
    test('toJson and fromJson serialization works correctly', () {
      final now = DateTime.now();
      final model = ExpenseModel(
        id: 'test_1',
        userId: 'user_1',
        amount: 99.99,
        category: 'Food & Dining',
        date: now,
        note: 'Team lunch',
        createdAt: now,
      );

      final json = model.toJson();
      final parsed = ExpenseModel.fromJson(json);

      expect(parsed.id, model.id);
      expect(parsed.userId, model.userId);
      expect(parsed.amount, model.amount);
      expect(parsed.category, model.category);
      expect(parsed.note, model.note);
    });

    test('toSqfliteMap and fromSqfliteMap serialization works correctly', () {
      final now = DateTime.now();
      final model = ExpenseModel(
        id: 'sqflite_1',
        userId: 'user_sqflite',
        amount: 250.75,
        category: 'Bills & Utilities',
        date: now,
        note: 'Internet bill',
        createdAt: now,
      );

      final map = model.toSqfliteMap();
      final parsed = ExpenseModel.fromSqfliteMap(map);

      expect(parsed.id, model.id);
      expect(parsed.userId, model.userId);
      expect(parsed.amount, model.amount);
      expect(parsed.category, model.category);
      expect(parsed.note, model.note);
      expect(parsed.date.toIso8601String(), model.date.toIso8601String());
    });

    test('Total expense and monthly calculations test', () {
      final now = DateTime.now();
      final lastMonth = DateTime(now.year, now.month - 1, 15);

      final expenses = [
        ExpenseModel(
          id: '1',
          userId: 'u1',
          amount: 100.0,
          category: 'Food',
          date: now,
          createdAt: now,
        ),
        ExpenseModel(
          id: '2',
          userId: 'u1',
          amount: 50.0,
          category: 'Transport',
          date: now,
          createdAt: now,
        ),
        ExpenseModel(
          id: '3',
          userId: 'u1',
          amount: 200.0,
          category: 'Shopping',
          date: lastMonth,
          createdAt: lastMonth,
        ),
      ];

      final total = expenses.fold(0.0, (sum, item) => sum + item.amount);
      final currentMonthTotal = expenses.where((e) {
        return e.date.year == now.year && e.date.month == now.month;
      }).fold(0.0, (sum, item) => sum + item.amount);

      expect(total, 350.0);
      expect(currentMonthTotal, 150.0);
    });
  });

  group('StorageService Keys Tests', () {
    test('Storage keys are defined correctly', () {
      expect(StorageService.keyIsLoggedIn, 'is_logged_in');
      expect(StorageService.keyUserEmail, 'user_email');
      expect(StorageService.keyUserName, 'user_name');
      expect(StorageService.keyIsDarkMode, 'is_dark_mode');
    });
  });

  group('DateFormatter Tests', () {
    test('formatCurrency formats amount with currency symbol', () {
      final formatted = DateFormatter.formatCurrency(150.50);
      expect(formatted, contains('\$'));
      expect(formatted, contains('150.50'));
    });

    test('formatShortDate returns non-empty formatted date string', () {
      final date = DateTime(2026, 8, 22);
      final formatted = DateFormatter.formatShortDate(date);
      expect(formatted, isNotEmpty);
      expect(formatted, contains('2026'));
    });

    test('formatMonthYear formats month and year correctly', () {
      final date = DateTime(2026, 8, 22);
      final formatted = DateFormatter.formatMonthYear(date);
      expect(formatted, contains('August'));
      expect(formatted, contains('2026'));
    });
  });

  group('AppConstants & Category Tests', () {
    test('AppConstants categories list is not empty', () {
      expect(AppConstants.categories, isNotEmpty);
      expect(AppConstants.categories, contains('Food & Dining'));
      expect(AppConstants.categories, contains('Bills & Utilities'));
    });

    test('getCategoryIcon returns appropriate IconData', () {
      expect(AppConstants.getCategoryIcon('Food & Dining'), Icons.restaurant);
      expect(AppConstants.getCategoryIcon('Transportation'), Icons.directions_car);
      expect(AppConstants.getCategoryIcon('Unknown'), Icons.category);
    });
  });

  group('Expense Filtering & Search Logic Tests', () {
    test('Category and Search Query filters correctly', () {
      final now = DateTime.now();
      final list = [
        ExpenseModel(
          id: '1',
          userId: 'u1',
          amount: 100.0,
          category: 'Food & Dining',
          date: now,
          note: 'Dinner with friends',
          createdAt: now,
        ),
        ExpenseModel(
          id: '2',
          userId: 'u1',
          amount: 45.0,
          category: 'Transport',
          date: now,
          note: 'Taxi ride',
          createdAt: now,
        ),
        ExpenseModel(
          id: '3',
          userId: 'u1',
          amount: 200.0,
          category: 'Shopping',
          date: now,
          note: 'New shoes',
          createdAt: now,
        ),
      ];

      // Category filter test
      final foodOnly = list.where((e) => e.category == 'Food & Dining').toList();
      expect(foodOnly.length, 1);
      expect(foodOnly.first.note, 'Dinner with friends');

      // Search query test (search by note 'Taxi')
      final searchTaxi = list.where((e) => (e.note ?? '').toLowerCase().contains('taxi')).toList();
      expect(searchTaxi.length, 1);
      expect(searchTaxi.first.amount, 45.0);

      // Search query test (search by category 'Shopping')
      final searchShopping = list.where((e) => e.category.toLowerCase().contains('shop')).toList();
      expect(searchShopping.length, 1);
      expect(searchShopping.first.id, '3');
    });
  });
}
