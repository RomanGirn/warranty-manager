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
  final bool compact;

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
    this.compact = false,
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
        padding: EdgeInsets.only(
            left: widget.compact ? 10 : 14, right: widget.compact ? 8 : 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.prefixIcon != null)
              Icon(widget.prefixIcon,
                  size: widget.compact ? 16 : 20, color: AppColors.textSecondary),
            if (widget.prefixIcon != null && widget.prefixText != null)
              const SizedBox(width: 8),
            if (widget.prefixText != null)
              Text(widget.prefixText!,
                  style: TextStyle(
                      fontSize: widget.compact ? 12 : 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
          ],
        ),
      );
    }

    Widget? suffix = widget.suffix;
    if (widget.isPassword) {
      suffix = IconButton(
        splashRadius: 18,
        padding: widget.compact ? EdgeInsets.zero : null,
        constraints: widget.compact
            ? const BoxConstraints(minWidth: 32, minHeight: 32)
            : null,
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
                      style: TextStyle(
                          fontSize: widget.compact ? 10 : 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                ),
                if (widget.labelTrailing != null) widget.labelTrailing!,
              ],
            ),
            SizedBox(height: widget.compact ? 4 : 8),
          ],
          TextField(
            controller: widget.controller,
            obscureText: widget.isPassword && _obscure,
            keyboardType: widget.keyboardType,
            readOnly: widget.readOnly,
            onChanged: widget.onChanged,
            style: TextStyle(fontSize: widget.compact ? 12 : 14),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                  color: const Color(0xFF9CA3AF), fontSize: widget.compact ? 12 : 14),
              prefixIcon: prefix,
              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              suffixIcon: suffix,
              suffixIconConstraints: widget.compact
                  ? const BoxConstraints(minWidth: 32, minHeight: 32)
                  : null,
              filled: true,
              fillColor: AppColors.field,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.compact ? 10 : 14, vertical: widget.compact ? 8 : 16),
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
