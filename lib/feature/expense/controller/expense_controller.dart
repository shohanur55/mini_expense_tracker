import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/route/app_route.dart';
import '../../../core/service/auth_service.dart';
import '../../../core/service/expense_service.dart';
import '../../../core/utility/snackbar_helper.dart';
import '../model/expense_model.dart';

class ExpenseController extends GetxController {
  static ExpenseController get to => Get.find<ExpenseController>();

  final ExpenseService _expenseService = ExpenseService.to;
  final AuthService _authService = AuthService.to;

  final RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxString selectedCategoryFilter = 'All'.obs;
  final RxString searchQuery = ''.obs;

  // Form Fields for Add/Edit Expense
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final RxnString selectedCategory = RxnString();
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();

  ExpenseModel? editingExpense;
  StreamSubscription<List<ExpenseModel>>? _expenseSubscription;

  @override
  void onInit() {
    super.onInit();
    _subscribeToExpenses();
    // Re-bind expenses when user login state changes
    ever(_authService.isLoggedIn, (_) => _subscribeToExpenses());
  }

  @override
  void onClose() {
    _expenseSubscription?.cancel();
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }

  String get userId => _authService.currentUserId.isNotEmpty
      ? _authService.currentUserId
      : (_authService.currentUserEmail.value ?? 'guest');

  void _subscribeToExpenses() {
    _expenseSubscription?.cancel();
    isLoading.value = true;

    try {
      _expenseSubscription = _expenseService.streamExpenses(userId).listen((list) {
        expenses.assignAll(list);
        isLoading.value = false;
      }, onError: (err) {
        fetchExpenses();
      });
    } catch (_) {
      fetchExpenses();
    }
  }

  Future<void> fetchExpenses() async {
    isLoading.value = true;
    try {
      final list = await _expenseService.getExpenses(userId);
      expenses.assignAll(list);
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to load expenses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Calculated Metrics
  double get totalExpense {
    return expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  double get currentMonthExpense {
    final now = DateTime.now();
    return expenses.where((e) {
      return e.date.year == now.year && e.date.month == now.month;
    }).fold(0.0, (sum, item) => sum + item.amount);
  }

  List<ExpenseModel> get recentExpenses {
    final sorted = List<ExpenseModel>.from(expenses)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(5).toList();
  }

  // Category & Search Filtered Expenses
  List<ExpenseModel> get filteredExpenses {
    return expenses.where((e) {
      final matchesCategory = selectedCategoryFilter.value == 'All' ||
          e.category.toLowerCase() == selectedCategoryFilter.value.toLowerCase();
      final query = searchQuery.value.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          e.category.toLowerCase().contains(query) ||
          (e.note != null && e.note!.toLowerCase().contains(query)) ||
          e.amount.toString().contains(query);

      return matchesCategory && matchesSearch;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Map<String, double> get categoryBreakdown {
    final Map<String, double> map = {};
    for (var e in expenses) {
      map[e.category] = (map[e.category] ?? 0.0) + e.amount;
    }
    return map;
  }

  void openAddExpense() {
    editingExpense = null;
    amountController.clear();
    noteController.clear();
    selectedCategory.value = null;
    selectedDate.value = DateTime.now();
    Get.toNamed(AppRoute.addExpense);
  }

  void openEditExpense(ExpenseModel expense) {
    editingExpense = expense;
    amountController.text = expense.amount.toStringAsFixed(2);
    noteController.text = expense.note ?? '';
    selectedCategory.value = expense.category;
    selectedDate.value = expense.date;
    Get.toNamed(AppRoute.editExpense);
  }

  Future<void> saveExpense() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedCategory.value == null) {
      SnackbarHelper.showError('Required Field', 'Please select a category');
      return;
    }
    if (selectedDate.value == null) {
      SnackbarHelper.showError('Required Field', 'Please select a date');
      return;
    }

    final amount = double.parse(amountController.text.trim());
    isSaving.value = true;

    try {
      final isEdit = editingExpense != null;
      if (!isEdit) {
        // Create New Expense
        final newExpense = ExpenseModel(
          id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
          userId: userId,
          amount: amount,
          category: selectedCategory.value!,
          date: selectedDate.value!,
          note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
          createdAt: DateTime.now(),
        );
        await _expenseService.addExpense(newExpense);
        if (!expenses.any((e) => e.id == newExpense.id)) {
          expenses.insert(0, newExpense);
        }
      } else {
        // Update Existing Expense
        final updated = editingExpense!.copyWith(
          amount: amount,
          category: selectedCategory.value!,
          date: selectedDate.value!,
          note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
        );
        await _expenseService.updateExpense(updated);
        final index = expenses.indexWhere((e) => e.id == updated.id);
        if (index != -1) {
          expenses[index] = updated;
        }
      }
      Get.back();
      if (!isEdit) {
        SnackbarHelper.showSuccess('Success', 'Expense added successfully');
      } else {
        SnackbarHelper.showSuccess('Updated', 'Expense details updated');
      }
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to save expense: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteExpense(ExpenseModel expense) async {
    try {
      await _expenseService.deleteExpense(expense.id, userId);
      expenses.removeWhere((e) => e.id == expense.id);
      SnackbarHelper.showSuccess('Deleted', 'Expense removed successfully');
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to delete expense: $e');
    }
  }
}
