import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../feature/expense/model/expense_model.dart';

class LocalDatabaseService extends GetxService {
  static LocalDatabaseService get to => Get.find<LocalDatabaseService>();

  Database? _db;
  static const String _tableName = 'expenses';

  Future<LocalDatabaseService> init() async {
    try {
      if (kIsWeb) return this;
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'expense_tracker.db');

      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE $_tableName (
              id TEXT PRIMARY KEY,
              userId TEXT NOT NULL,
              amount REAL NOT NULL,
              category TEXT NOT NULL,
              date TEXT NOT NULL,
              note TEXT,
              createdAt TEXT NOT NULL
            )
          ''');
        },
      );
    } catch (e) {
      debugPrint('SQLite initialization error: $e');
    }
    return this;
  }

  Future<void> insertExpense(ExpenseModel expense) async {
    if (_db == null) return;
    try {
      await _db!.insert(
        _tableName,
        expense.toSqfliteMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('SQLite insert error: $e');
    }
  }

  Future<List<ExpenseModel>> getExpenses(String userId) async {
    if (_db == null) return [];
    try {
      final List<Map<String, dynamic>> maps = await _db!.query(
        _tableName,
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'date DESC',
      );

      return maps.map((map) => ExpenseModel.fromSqfliteMap(map)).toList();
    } catch (e) {
      debugPrint('SQLite query error: $e');
      return [];
    }
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    if (_db == null) return;
    try {
      await _db!.update(
        _tableName,
        expense.toSqfliteMap(),
        where: 'id = ?',
        whereArgs: [expense.id],
      );
    } catch (e) {
      debugPrint('SQLite update error: $e');
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    if (_db == null) return;
    try {
      await _db!.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [expenseId],
      );
    } catch (e) {
      debugPrint('SQLite delete error: $e');
    }
  }

  Future<void> saveAllExpenses(List<ExpenseModel> expenses) async {
    if (_db == null || expenses.isEmpty) return;
    try {
      final batch = _db!.batch();
      for (var expense in expenses) {
        batch.insert(
          _tableName,
          expense.toSqfliteMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      debugPrint('SQLite batch save error: $e');
    }
  }
}
