import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Mini Expense Tracker';
  static const String currencySymbol = '\$';

  static const List<String> categories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Bills & Utilities',
    'Entertainment',
    'Health & Fitness',
    'Others',
  ];

  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food & dining':
      case 'food':
        return Icons.restaurant;
      case 'transportation':
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'bills & utilities':
      case 'bills':
        return Icons.receipt_long;
      case 'entertainment':
        return Icons.movie;
      case 'health & fitness':
      case 'health':
        return Icons.medical_services;
      default:
        return Icons.category;
    }
  }
}
