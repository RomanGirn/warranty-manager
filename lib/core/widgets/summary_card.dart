import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_card.dart';
import 'chips.dart';

/// "Мої покупки" overview block with a progress bar and legend.
class SummaryCard extends StatelessWidget {
  final String title;
  final int total;
  final int active;
  final int expired;

  const SummaryCard({
    super.key,
    required this.title,
    required this.total,
    required this.active,
    required this.expired,
  });

  Widget _legend(String text, Color color) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 6),
          Text(text,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text('Всього товарів: $total',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const InfoChip(label: '2 за тиждень', icon: Icons.update),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : active / total,
              minHeight: 8,
              backgroundColor: AppColors.border,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 20,
            runSpacing: 6,
            children: [
              _legend('Гарантійні: $active', AppColors.success),
              _legend('Закінчені: $expired', AppColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }
}
