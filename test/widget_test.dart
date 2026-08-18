import 'package:flutter_test/flutter_test.dart';
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
  });
}
