import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Places children side by side on wide screens and stacks them on narrow ones.
class FormRow extends StatelessWidget {
  final List<Widget> children;
  final double gap;
  final double breakpoint;

  const FormRow({super.key, required this.children, this.gap = 16, this.breakpoint = 480});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= breakpoint) {
        final row = <Widget>[];
        for (var i = 0; i < children.length; i++) {
          if (i > 0) row.add(SizedBox(width: gap));
          row.add(Expanded(child: children[i]));
        }
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: row);
      }
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
    });
  }
}

/// Checkbox with a text label.
class LabeledCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget label;

  const LabeledCheckbox({super.key, required this.value, required this.onChanged, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              activeColor: AppColors.accent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              onChanged: (v) => onChanged(v ?? false),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(child: label),
        ],
      ),
    );
  }
}

/// Switch row with a title and description (notification settings).
class SettingSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeTrackColor: AppColors.accent),
        ],
      ),
    );
  }
}

/// Styled dropdown that matches [AppTextField].
class AppDropdown extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const AppDropdown({
    super.key,
    this.icon,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            borderRadius: BorderRadius.circular(12),
            dropdownColor: Colors.white,
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              prefixIcon: icon == null
                  ? null
                  : Icon(icon, size: 20, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.field,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ],
      ),
    );
  }
}

/// Segmented selector (Світла / Темна / Авто).
class SegmentedSelector extends StatelessWidget {
  final String label;
  final List<String> options;
  final List<IconData> icons;
  final int selected;
  final ValueChanged<int> onChanged;

  const SegmentedSelector({
    super.key,
    required this.label,
    required this.options,
    required this.icons,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration:
                BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: List.generate(options.length, (i) {
                final active = i == selected;
                return Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(9),
                    onTap: () => onChanged(i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: active ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(9),
                        boxShadow: active
                            ? const [BoxShadow(color: Color(0x14000000), blurRadius: 6)]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icons[i],
                              size: 16,
                              color: active ? AppColors.accent : AppColors.textSecondary),
                          const SizedBox(width: 6),
                          Text(options[i],
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: active ? AppColors.accent : AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// Page heading used at the top of shell screens.
class PageTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const PageTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          ],
        ],
      ),
    );
  }
}
