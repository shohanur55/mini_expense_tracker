import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary Colors
  static const Color primary = Color(0xFF0D9488); // Emerald 600
  static const Color primaryLight = Color(0xFF2DD4BF); // Teal 400
  static const Color primaryDark = Color(0xFF0F766E); // Teal 700
  static const Color primarySoft = Color(0xFFCCFBF1); // Teal 100

  // Secondary Accent Colors
  static const Color secondary = Color(0xFF6366F1); // Indigo 500
  static const Color secondarySoft = Color(0xFFE0E7FF); // Indigo 100

  // Neutral Colors (Light Theme)
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0); // Slate 200
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate 900
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate 500
  static const Color lightTextMuted = Color(0xFF94A3B8); // Slate 400

  // Neutral Colors (Dark Theme)
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155); // Slate 700
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color darkTextMuted = Color(0xFF64748B); // Slate 500

  // Semantic Status Colors
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color info = Color(0xFF3B82F6); // Blue 500

  // Category Colors
  static const Color catFood = Color(0xFFF97316); // Orange
  static const Color catTransport = Color(0xFF06B6D4); // Cyan
  static const Color catShopping = Color(0xFFEC4899); // Pink
  static const Color catBills = Color(0xFF8B5CF6); // Purple
  static const Color catEntertainment = Color(0xFFF59E0B); // Amber
  static const Color catHealth = Color(0xFF10B981); // Emerald
  static const Color catOthers = Color(0xFF64748B); // Slate

  // Helper method for Category Color mapping
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food & dining':
      case 'food':
        return catFood;
      case 'transportation':
      case 'transport':
        return catTransport;
      case 'shopping':
        return catShopping;
      case 'bills & utilities':
      case 'bills':
        return catBills;
      case 'entertainment':
        return catEntertainment;
      case 'health & fitness':
      case 'health':
        return catHealth;
      default:
        return catOthers;
    }
  }

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF0F766E), Color(0xFF0D9488), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
