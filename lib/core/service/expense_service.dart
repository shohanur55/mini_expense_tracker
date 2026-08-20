import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../feature/expense/model/expense_model.dart';

class ExpenseService extends GetxService {
  static ExpenseService get to => Get.find<ExpenseService>();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();

  static const String _expensesKey = 'user_expenses_list';

  CollectionReference<Map<String, dynamic>> _userExpensesRef(String userId) {
    final uid = userId.isNotEmpty ? userId : 'guest_user';
    return _firestore.collection('users').doc(uid).collection('expenses');
  }

  /// Real-time stream of expenses for a specific user
  Stream<List<ExpenseModel>> streamExpenses(String userId) {
    if (userId.isEmpty) return Stream.value([]);

    return _userExpensesRef(userId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map((doc) {
        return ExpenseModel.fromJson(doc.data(), docId: doc.id);
      }).toList();

      list.sort((a, b) => b.date.compareTo(a.date));
      return list;
    }).handleError((error) {
      debugPrint('Firestore stream error fallback to storage: $error');
      return getExpenses(userId);
    });
  }

  /// Get expenses with Firestore query & fallback offline cache
  Future<List<ExpenseModel>> getExpenses(String userId) async {
    final targetUid = userId.isNotEmpty ? userId : 'guest_user';

    try {
      final snapshot = await _userExpensesRef(targetUid).get();
      
      final List<ExpenseModel> items = snapshot.docs.map((doc) {
        return ExpenseModel.fromJson(doc.data(), docId: doc.id);
      }).toList();

      if (items.isNotEmpty) {
        items.sort((a, b) => b.date.compareTo(a.date));
        // Cache to local storage
        await _saveToLocalStorage(items);
        return items;
      }
    } catch (e) {
      debugPrint('Firestore fetch expenses error, using local fallback: $e');
    }

    // Fallback to local storage cache if Firestore fetch returns empty or offline
    final rawList = _storage.read<List<dynamic>>(_expensesKey) ?? [];
    final List<ExpenseModel> userExpenses = [];
    for (var item in rawList) {
      if (item is Map<String, dynamic>) {
        final expense = ExpenseModel.fromJson(item);
        if (expense.userId == targetUid || targetUid == 'guest_user' || expense.userId.isEmpty) {
          userExpenses.add(expense);
        }
      }
    }

    // Seed default mock expenses if user has no expenses yet
    if (userExpenses.isEmpty && targetUid.isNotEmpty) {
      final initialMocks = _generateDefaultMocks(targetUid);
      for (var mock in initialMocks) {
        await addExpense(mock);
      }
      return initialMocks;
    }

    userExpenses.sort((a, b) => b.date.compareTo(a.date));
    return userExpenses;
  }

  Future<void> addExpense(ExpenseModel expense) async {
    final targetUid = expense.userId.isNotEmpty ? expense.userId : 'guest_user';
    
    // Save to Firestore
    try {
      await _userExpensesRef(targetUid).doc(expense.id).set(expense.toJson());
    } catch (e) {
      debugPrint('Firestore add expense error: $e');
    }

    // Save to local storage cache
    final rawList = _storage.read<List<dynamic>>(_expensesKey) ?? [];
    rawList.add(expense.toJson());
    await _storage.write(_expensesKey, rawList);
  }

  Future<void> updateExpense(ExpenseModel updatedExpense) async {
    final targetUid = updatedExpense.userId.isNotEmpty ? updatedExpense.userId : 'guest_user';

    // Update in Firestore
    try {
      await _userExpensesRef(targetUid).doc(updatedExpense.id).update(updatedExpense.toJson());
    } catch (e) {
      debugPrint('Firestore update expense error: $e');
    }

    // Update in local storage cache
    final rawList = _storage.read<List<dynamic>>(_expensesKey) ?? [];
    final index = rawList.indexWhere(
      (element) => element is Map && element['id'] == updatedExpense.id,
    );

    if (index != -1) {
      rawList[index] = updatedExpense.toJson();
      await _storage.write(_expensesKey, rawList);
    }
  }

  Future<void> deleteExpense(String expenseId, String userId) async {
    final targetUid = userId.isNotEmpty ? userId : 'guest_user';

    // Delete in Firestore
    try {
      await _userExpensesRef(targetUid).doc(expenseId).delete();
    } catch (e) {
      debugPrint('Firestore delete expense error: $e');
    }

    // Delete in local storage cache
    final rawList = _storage.read<List<dynamic>>(_expensesKey) ?? [];
    rawList.removeWhere(
      (element) => element is Map && element['id'] == expenseId,
    );
    await _storage.write(_expensesKey, rawList);
  }

  Future<void> _saveToLocalStorage(List<ExpenseModel> expenses) async {
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
