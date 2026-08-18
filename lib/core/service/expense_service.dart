import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../feature/expense/model/expense_model.dart';

class ExpenseService extends GetxService {
  static ExpenseService get to => Get.find<ExpenseService>();
  final _storage = GetStorage();

  static const String _expensesKey = 'user_expenses_list';

  Future<List<ExpenseModel>> getExpenses(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate async fetch
    final rawList = _storage.read<List<dynamic>>(_expensesKey) ?? [];

    final List<ExpenseModel> userExpenses = [];
    for (var item in rawList) {
      if (item is Map<String, dynamic>) {
        final expense = ExpenseModel.fromJson(item);
        if (expense.userId == userId || userId.isEmpty) {
          userExpenses.add(expense);
        }
      }
    }

    // Default mock expenses if user has no expenses initially (for demo excellence)
    if (userExpenses.isEmpty && userId.isNotEmpty) {
      final initialMocks = _generateDefaultMocks(userId);
      await saveAllExpenses(initialMocks);
      return initialMocks;
    }

    // Sort by date descending (newest first)
    userExpenses.sort((a, b) => b.date.compareTo(a.date));
    return userExpenses;
  }

  Future<void> addExpense(ExpenseModel expense) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final rawList = _storage.read<List<dynamic>>(_expensesKey) ?? [];
    rawList.add(expense.toJson());
    await _storage.write(_expensesKey, rawList);
  }

  Future<void> updateExpense(ExpenseModel updatedExpense) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final rawList = _storage.read<List<dynamic>>(_expensesKey) ?? [];
    final index = rawList.indexWhere(
      (element) => element is Map && element['id'] == updatedExpense.id,
    );

    if (index != -1) {
      rawList[index] = updatedExpense.toJson();
      await _storage.write(_expensesKey, rawList);
    } else {
      throw 'Expense not found to update';
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final rawList = _storage.read<List<dynamic>>(_expensesKey) ?? [];
    rawList.removeWhere(
      (element) => element is Map && element['id'] == expenseId,
    );
    await _storage.write(_expensesKey, rawList);
  }

  Future<void> saveAllExpenses(List<ExpenseModel> expenses) async {
    final rawList = expenses.map((e) => e.toJson()).toList();
    await _storage.write(_expensesKey, rawList);
  }

  List<ExpenseModel> _generateDefaultMocks(String userId) {
    final now = DateTime.now();
    return [
      ExpenseModel(
        id: 'mock_1',
        userId: userId,
        amount: 45.50,
        category: 'Food & Dining',
        date: now.subtract(const Duration(hours: 3)),
        note: 'Grocery shopping & fresh veggies',
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      ExpenseModel(
        id: 'mock_2',
        userId: userId,
        amount: 25.00,
        category: 'Transportation',
        date: now.subtract(const Duration(days: 1)),
        note: 'Uber ride to city center',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      ExpenseModel(
        id: 'mock_3',
        userId: userId,
        amount: 120.00,
        category: 'Bills & Utilities',
        date: now.subtract(const Duration(days: 2)),
        note: 'Electricity bill payment',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      ExpenseModel(
        id: 'mock_4',
        userId: userId,
        amount: 89.99,
        category: 'Shopping',
        date: now.subtract(const Duration(days: 4)),
        note: 'New sneakers',
        createdAt: now.subtract(const Duration(days: 4)),
      ),
      ExpenseModel(
        id: 'mock_5',
        userId: userId,
        amount: 15.00,
        category: 'Entertainment',
        date: now.subtract(const Duration(days: 6)),
        note: 'Cinema ticket',
        createdAt: now.subtract(const Duration(days: 6)),
      ),
    ];
  }
}
