import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'brand.dart';
import 'chips.dart';

class _NavDef {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String? route; // null = the button does nothing
  final bool badge;
  const _NavDef(this.label, this.icon, this.activeIcon, this.route, {this.badge = false});
}

/// Page frame for logged-in screens. Navigation lives in a top bar
/// (the usual pattern on the web) instead of a bottom tab bar.
class AppShell extends StatelessWidget {
  final int currentIndex;
  final Widget child;
  final Widget? floatingActionButton;

  /// Same content width on every logged-in screen.
  static const double maxContentWidth = 1400;

  const AppShell({
    super.key,
    required this.currentIndex,
    required this.child,
    this.floatingActionButton,
  });

  static const _items = [
    _NavDef('Головна', Icons.home_outlined, Icons.home_rounded, '/home'),
    _NavDef('Сповіщення', Icons.notifications_none, Icons.notifications, null, badge: true),
    _NavDef('Профіль', Icons.person_outline, Icons.person, '/profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: Column(
        children: [
          _TopBar(currentIndex: currentIndex, maxWidth: AppShell.maxContentWidth),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 96),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: AppShell.maxContentWidth),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final int currentIndex;
  final double maxWidth;
  const _TopBar({required this.currentIndex, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      child: Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
        child: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: LayoutBuilder(builder: (context, c) {
                final compact = c.maxWidth < 720;
                return SizedBox(
                  height: 64,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const BrandLogo(size: 36),
                        if (c.maxWidth >= 480) ...[
                          const SizedBox(width: 12),
                          const Text('Менеджер гарантій',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        ],
                        const Spacer(),
                        for (var i = 0; i < AppShell._items.length; i++)
                          _NavButton(
                            def: AppShell._items[i],
                            selected: i == currentIndex,
                            compact: compact,
                          ),
                        if (!compact) ...[
                          const SizedBox(width: 12),
                          const InfoChip(
                            label: MockData.syncLabel,
                            icon: Icons.cloud_done_outlined,
                            color: AppColors.info,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final _NavDef def;
  final bool selected;
  final bool compact;
  const _NavButton({required this.def, required this.selected, required this.compact});

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accent : AppColors.textSecondary;
    final icon = Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(selected ? def.activeIcon : def.icon, size: 22, color: color),
        if (def.badge)
          Positioned(
            right: -1,
            top: -1,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
            ),
          ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Tooltip(
        message: def.label,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: (selected || def.route == null)
              ? null
              : () => Navigator.pushReplacementNamed(context, def.route!),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 14, vertical: 9),
            decoration: BoxDecoration(
              color: selected ? AppColors.field : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                if (!compact) ...[
                  const SizedBox(width: 8),
                  Text(def.label,
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600, color: color)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}