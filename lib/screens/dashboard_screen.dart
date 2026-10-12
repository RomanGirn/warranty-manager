import 'package:flutter/material.dart';
import '../core/data/mock_data.dart';
import '../core/models/warranty_item.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _query = '';

  /// Search by item name only; all four items are shown when the query is empty.
  List<WarrantyItem> get _visible {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return MockData.items;
    return MockData.items.where((i) => i.title.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _visible;
    // Status buttons are display-only (disabled): label + dot colour.
    const statusChips = <(String, Color)>[
      ('Активні (${MockData.activeItems})', AppColors.success),
      ('Закінчуються (${MockData.expiringItems})', AppColors.warning),
      ('Закінчені (${MockData.expiredItems})', AppColors.textSecondary),
    ];

    return AppShell(
      currentIndex: 0,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Додати товар'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SummaryCard(
            title: 'Мої покупки',
            total: MockData.totalItems,
            active: MockData.activeItems,
            expired: MockData.expiredItems,
          ),
          const SizedBox(height: 20),
          AppTextField(
            hint: 'Пошук за назвою товару...',
            prefixIcon: Icons.search,
            bottomSpacing: 14,
            onChanged: (v) => setState(() => _query = v),
            suffix: IconButton(
              icon: const Icon(Icons.tune, size: 20, color: AppColors.textSecondary),
              onPressed: () {},
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const SelectableChip(label: 'Всі (${MockData.totalItems})', selected: true),
              for (final chip in statusChips)
                SelectableChip(label: chip.$1, dotColor: chip.$2, selected: false), // onTap null = disabled
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.swap_vert, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              const Text('За датою покупки',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const Spacer(),
              Text('Відображено ${items.length} з ${MockData.totalItems}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const AppCard(
              child: Center(
                child: Text('Нічого не знайдено. Змініть пошуковий запит або фільтр.',
                    style: TextStyle(color: AppColors.textSecondary)),
              ),
            )
          else
            LayoutBuilder(builder: (context, c) {
              const gap = 16.0;
              final columns = c.maxWidth >= 820 ? 2 : 1;
              final width = (c.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final item in items)
                    SizedBox(
                      width: width,
                      child: WarrantyCard(item: item, onView: () {}, onEdit: () {}),
                    ),
                ],
              );
            }),
        ],
      ),
    );
  }
}
