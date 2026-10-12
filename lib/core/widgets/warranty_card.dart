import 'package:flutter/material.dart';
import '../models/warranty_item.dart';
import '../theme/app_theme.dart';
import 'app_buttons.dart';
import 'app_card.dart';
import 'chips.dart';

/// Card for one purchase in the list on the home screen.
class WarrantyCard extends StatelessWidget {
  final WarrantyItem item;
  final VoidCallback? onView;
  final VoidCallback? onEdit;

  const WarrantyCard({super.key, required this.item, this.onView, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final color = item.status.color;
    final expired = item.status == WarrantyStatus.expired;

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    color: AppColors.field, borderRadius: BorderRadius.circular(12)),
                child: Icon(item.icon, color: AppColors.accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.category,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.accent)),
                    const SizedBox(height: 2),
                    Text(item.title,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text('${item.purchaseDate} • ${item.price}',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: AppColors.textSecondary),
            ],
          ),
          if (item.documentTitle != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.field, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long_outlined,
                      size: 22, color: AppColors.textSecondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.documentTitle!,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        if (item.documentNote != null) ...[
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              if (item.documentNoteIcon != null)
                                Icon(item.documentNoteIcon,
                                    size: 13, color: item.documentNoteColor),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(item.documentNote!,
                                    style: TextStyle(
                                        fontSize: 12, color: item.documentNoteColor)),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const InfoChip(label: 'Чек', color: AppColors.textSecondary, background: Colors.white),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(item.statusLabel,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
              ),
              Text(item.endLabel,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: item.progress,
              minHeight: 6,
              backgroundColor: AppColors.border,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: expired
                    ? SecondaryButton(
                        text: 'Архівні деталі', icon: Icons.history, height: 42, onPressed: onView)
                    : PrimaryButton(
                        text: 'Переглянути',
                        icon: Icons.visibility_outlined,
                        height: 42,
                        onPressed: onView),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SecondaryButton(
                  text: expired ? 'Продовжити' : 'Редагувати',
                  icon: expired ? Icons.refresh : Icons.edit_outlined,
                  height: 42,
                  onPressed: onEdit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
