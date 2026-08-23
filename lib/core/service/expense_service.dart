import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../feature/expense/model/expense_model.dart';
import 'local_database_service.dart';

class ExpenseService extends GetxService {
  static ExpenseService get to => Get.find<ExpenseService>();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  LocalDatabaseService get _db => LocalDatabaseService.to;

  CollectionReference<Map<String, dynamic>> _userExpensesRef(String userId) {
    final uid = userId.isNotEmpty ? userId : 'guest_user';
    return _firestore.collection('users').doc(uid).collection('expenses');
  }

  /// Real-time stream of expenses for a specific user from Firestore & SQLite
  Stream<List<ExpenseModel>> streamExpenses(String userId) {
    if (userId.isEmpty) return Stream.value([]);
    final targetUid = userId.isNotEmpty ? userId : 'guest_user';

    return _userExpensesRef(targetUid)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map((doc) {
        return ExpenseModel.fromJson(doc.data(), docId: doc.id);
      }).toList();

      list.sort((a, b) => b.date.compareTo(a.date));
      _db.saveAllExpenses(list);
      return list;
    });
  }

  /// Get expenses from local SQLite database first, then sync from Firestore
  Future<List<ExpenseModel>> getExpenses(String userId) async {
    final targetUid = userId.isNotEmpty ? userId : 'guest_user';

    // 1. Load local expenses from SQLite
    final localList = await _db.getExpenses(targetUid);

    // 2. Fetch fresh expenses from Firestore asynchronously
    try {
      final snapshot = await _userExpensesRef(targetUid).get();
      final List<ExpenseModel> remoteList = snapshot.docs.map((doc) {
        return ExpenseModel.fromJson(doc.data(), docId: doc.id);
      }).toList();

      remoteList.sort((a, b) => b.date.compareTo(a.date));
      await _db.saveAllExpenses(remoteList);
      return remoteList.isNotEmpty ? remoteList : localList;
    } catch (e) {
      debugPrint('Firestore fetch expenses fallback to SQLite: $e');
      return localList;
    }
  }

  Future<bool> addExpense(ExpenseModel expense) async {
    final targetUid = expense.userId.isNotEmpty ? expense.userId : 'guest_user';
    
    // Save to local SQLite database immediately
    await _db.insertExpense(expense);

    // Sync with Firestore
    try {
      await _userExpensesRef(targetUid)
          .doc(expense.id)
          .set(expense.toJson())
          .timeout(const Duration(seconds: 2));
      return true;
    } catch (e) {
      debugPrint('Firestore add expense error/offline: $e');
      return false;
    }
  }

  Future<bool> updateExpense(ExpenseModel updatedExpense) async {
    final targetUid = updatedExpense.userId.isNotEmpty ? updatedExpense.userId : 'guest_user';
    
    // Update local SQLite database immediately
    await _db.updateExpense(updatedExpense);

    // Sync with Firestore
    try {
      await _userExpensesRef(targetUid)
          .doc(updatedExpense.id)
          .update(updatedExpense.toJson())
          .timeout(const Duration(seconds: 2));
      return true;
    } catch (e) {
      debugPrint('Firestore update expense error/offline: $e');
      return false;
    }
  }

  Future<bool> deleteExpense(String expenseId, String userId) async {
    final targetUid = userId.isNotEmpty ? userId : 'guest_user';
    
    // Delete from local SQLite database immediately
    await _db.deleteExpense(expenseId);

    // Sync with Firestore
    try {
      await _userExpensesRef(targetUid)
          .doc(expenseId)
          .delete()
          .timeout(const Duration(seconds: 2));
      return true;
    } catch (e) {
      debugPrint('Firestore delete expense error/offline: $e');
      return false;
    }
  }
}
