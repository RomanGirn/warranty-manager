import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Small read-only label (sync status, plan badge, "Чек").
class InfoChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final Color background;

  const InfoChip({
    super.key,
    required this.label,
    this.icon,
    this.color = AppColors.accent,
    this.background = AppColors.infoBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: color), const SizedBox(width: 6)],
          Text(label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

/// Filter chip with an optional coloured dot (Всі / Активні / ...).
class SelectableChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? dotColor;
  final VoidCallback? onTap; // null = disabled

  const SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
    this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null && !selected ? 0.55 : 1,
      child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.gradient : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? Colors.transparent : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dotColor != null && !selected) ...[
              Icon(Icons.circle, size: 8, color: dotColor),
              const SizedBox(width: 6),
            ],
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textPrimary)),
          ],
        ),
      ),
    ),
    );
  }
}
