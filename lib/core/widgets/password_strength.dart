import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Pure UI helpers for the password hints (no real validation logic).
class PasswordRules {
  static bool hasLength(String p) => p.length >= 8;
  static bool hasDigit(String p) => RegExp(r'\d').hasMatch(p);
  static bool hasSpecial(String p) => RegExp(r'[^\w\s]').hasMatch(p);

  static int score(String p) =>
      (hasLength(p) ? 1 : 0) + (hasDigit(p) ? 1 : 0) + (hasSpecial(p) ? 1 : 0);

  static String label(int score) {
    switch (score) {
      case 1:
        return 'Слабкий';
      case 2:
        return 'Середній';
      case 3:
        return 'Надійний';
      default:
        return 'Введіть пароль';
    }
  }

  static Color color(int score) {
    switch (score) {
      case 1:
        return AppColors.danger;
      case 2:
        return AppColors.warning;
      case 3:
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }
}

/// Three-segment strength bar with a caption.
class PasswordStrengthBar extends StatelessWidget {
  final String password;
  const PasswordStrengthBar({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final score = PasswordRules.score(password);
    final color = PasswordRules.color(score);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Складність пароля',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ),
            Text(PasswordRules.label(score),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(3, (i) {
            return Expanded(
              child: Container(
                height: 5,
                margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                decoration: BoxDecoration(
                  color: i < score ? color : AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

/// "8+ символів / Цифри / Спецсимволи" checklist.
class PasswordRequirements extends StatelessWidget {
  final String password;
  final bool compact;
  const PasswordRequirements({super.key, required this.password, this.compact = false});

  Widget _item(String text, bool ok) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(ok ? Icons.check_circle : Icons.radio_button_unchecked,
            size: compact ? 14 : 16, color: ok ? AppColors.accent : AppColors.textSecondary),
        SizedBox(width: compact ? 4 : 6),
        Text(text,
            style: TextStyle(
                fontSize: compact ? 10 : 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 14, vertical: compact ? 5 : 12),
      decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(12)),
      child: Wrap(
        spacing: compact ? 8 : 24,
        runSpacing: compact ? 4 : 8,
        alignment: WrapAlignment.spaceBetween,
        children: [
          _item('8+ символів', PasswordRules.hasLength(password)),
          _item('Цифри', PasswordRules.hasDigit(password)),
          _item('Спецсимволи', PasswordRules.hasSpecial(password)),
        ],
      ),
    );
  }
}
