import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Styled text input with an optional label, prefix icon/text and
/// built-in show/hide toggle for passwords.
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final String? prefixText;
  final bool isPassword;
  final bool readOnly;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? labelTrailing;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final double bottomSpacing;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.prefixIcon,
    this.prefixText,
    this.isPassword = false,
    this.readOnly = false,
    this.controller,
    this.keyboardType,
    this.labelTrailing,
    this.suffix,
    this.onChanged,
    this.bottomSpacing = 16,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  OutlineInputBorder _border(Color color, [double width = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    Widget? prefix;
    if (widget.prefixIcon != null || widget.prefixText != null) {
      prefix = Padding(
        padding: const EdgeInsets.only(left: 14, right: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.prefixIcon != null)
              Icon(widget.prefixIcon, size: 20, color: AppColors.textSecondary),
            if (widget.prefixIcon != null && widget.prefixText != null)
              const SizedBox(width: 8),
            if (widget.prefixText != null)
              Text(widget.prefixText!,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ],
        ),
      );
    }

    Widget? suffix = widget.suffix;
    if (widget.isPassword) {
      suffix = IconButton(
        splashRadius: 18,
        icon: Icon(
          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 20,
          color: AppColors.textSecondary,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: widget.bottomSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(widget.label!,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ),
                if (widget.labelTrailing != null) widget.labelTrailing!,
              ],
            ),
            const SizedBox(height: 8),
          ],
          TextField(
            controller: widget.controller,
            obscureText: widget.isPassword && _obscure,
            keyboardType: widget.keyboardType,
            readOnly: widget.readOnly,
            onChanged: widget.onChanged,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              prefixIcon: prefix,
              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              suffixIcon: suffix,
              filled: true,
              fillColor: AppColors.field,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              border: _border(Colors.transparent),
              enabledBorder: _border(Colors.transparent),
              focusedBorder: _border(AppColors.primary, 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
