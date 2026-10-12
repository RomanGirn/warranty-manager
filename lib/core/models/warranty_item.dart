import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum WarrantyStatus { active, expiring, critical, expired }

extension WarrantyStatusX on WarrantyStatus {
  Color get color {
    switch (this) {
      case WarrantyStatus.active:
        return AppColors.success;
      case WarrantyStatus.expiring:
        return AppColors.warning;
      case WarrantyStatus.critical:
        return AppColors.danger;
      case WarrantyStatus.expired:
        return AppColors.textSecondary;
    }
  }
}

class WarrantyItem {
  final String category;
  final String title;
  final String purchaseDate;
  final String price;
  final IconData icon;
  final String? documentTitle;
  final String? documentNote;
  final IconData? documentNoteIcon;
  final Color? documentNoteColor;
  final String statusLabel;
  final String endLabel;
  final double progress;
  final WarrantyStatus status;

  const WarrantyItem({
    required this.category,
    required this.title,
    required this.purchaseDate,
    required this.price,
    required this.icon,
    required this.statusLabel,
    required this.endLabel,
    required this.progress,
    required this.status,
    this.documentTitle,
    this.documentNote,
    this.documentNoteIcon,
    this.documentNoteColor,
  });
}
