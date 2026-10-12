import 'package:flutter/material.dart';

/// Colours taken from the reference screenshots.
class AppColors {
  static const primary = Color(0xFF667EEA);
  static const primaryDark = Color(0xFF764BA2);
  static const accent = Color(0xFF4F46E5);
  static const background = Color(0xFFF5F7FB);
  static const field = Color(0xFFF0F4FF);
  static const border = Color(0xFFE5E7EB);
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);
  static const dangerBg = Color(0xFFFEE2E2);
  static const info = Color(0xFF3B82F6);
  static const infoBg = Color(0xFFE8EEFF);

  static const gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, primaryDark],
  );
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter', // falls back to the system font if not bundled
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent)
            .copyWith(primary: AppColors.accent),
        dividerColor: AppColors.border,
      );
}
