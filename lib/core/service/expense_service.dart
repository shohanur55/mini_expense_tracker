import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../feature/expense/model/expense_model.dart';

class ExpenseService extends GetxService {
  static ExpenseService get to => Get.find<ExpenseService>();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userExpensesRef(String userId) {
    final uid = userId.isNotEmpty ? userId : 'guest_user';
    return _firestore.collection('users').doc(uid).collection('expenses');
  }

  /// Real-time stream of expenses for a specific user from Firestore
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
    });
  }

  /// Get expenses with Firestore query
  Future<List<ExpenseModel>> getExpenses(String userId) async {
    final targetUid = userId.isNotEmpty ? userId : 'guest_user';

    try {
      final snapshot = await _userExpensesRef(targetUid).get();
      
      final List<ExpenseModel> items = snapshot.docs.map((doc) {
        return ExpenseModel.fromJson(doc.data(), docId: doc.id);
      }).toList();

      items.sort((a, b) => b.date.compareTo(a.date));
      return items;
    } catch (e) {
      debugPrint('Firestore fetch expenses error: $e');
      return [];
    }
  }

  Future<void> addExpense(ExpenseModel expense) async {
    final targetUid = expense.userId.isNotEmpty ? expense.userId : 'guest_user';
    try {
      await _userExpensesRef(targetUid).doc(expense.id).set(expense.toJson());
    } catch (e) {
      debugPrint('Firestore add expense error: $e');
    }
  }

  Future<void> updateExpense(ExpenseModel updatedExpense) async {
    final targetUid = updatedExpense.userId.isNotEmpty ? updatedExpense.userId : 'guest_user';
    try {
      await _userExpensesRef(targetUid).doc(updatedExpense.id).update(updatedExpense.toJson());
    } catch (e) {
      debugPrint('Firestore update expense error: $e');
    }
  }

  Future<void> deleteExpense(String expenseId, String userId) async {
    final targetUid = userId.isNotEmpty ? userId : 'guest_user';
    try {
      await _userExpensesRef(targetUid).doc(expenseId).delete();
    } catch (e) {
      debugPrint('Firestore delete expense error: $e');
    }
  }
}
