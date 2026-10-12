import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _ButtonShell extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool iconAfter;
  final Gradient? gradient;
  final Color? background;
  final Color foreground;
  final double height;
  final bool shadow;

  const _ButtonShell({
    required this.text,
    required this.onPressed,
    required this.foreground,
    this.icon,
    this.iconAfter = false,
    this.gradient,
    this.background,
    this.height = 48,
    this.shadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);
    final iconWidget = icon == null ? null : Icon(icon, size: 18, color: foreground);
    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? background : null,
          borderRadius: radius,
          boxShadow: shadow
              ? const [BoxShadow(color: Color(0x40667EEA), blurRadius: 12, offset: Offset(0, 4))]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: radius,
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (iconWidget != null && !iconAfter) ...[iconWidget, const SizedBox(width: 8)],
                  Flexible(
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: foreground, fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ),
                  if (iconWidget != null && iconAfter) ...[const SizedBox(width: 8), iconWidget],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Main gradient button (Увійти, Зареєструватися, Переглянути...).
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool iconAfter;
  final double height;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconAfter = false,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) => _ButtonShell(
        text: text,
        onPressed: onPressed,
        icon: icon,
        iconAfter: iconAfter,
        height: height,
        gradient: AppColors.gradient,
        foreground: Colors.white,
        shadow: true,
      );
}

/// Light tinted button (Редагувати, Скасувати, Вийти з акаунта...).
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) => _ButtonShell(
        text: text,
        onPressed: onPressed,
        icon: icon,
        height: height,
        background: AppColors.infoBg,
        foreground: AppColors.accent,
      );
}

/// Destructive action button (Видалити акаунт).
class DangerButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const DangerButton({super.key, required this.text, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) => _ButtonShell(
        text: text,
        onPressed: onPressed,
        icon: icon,
        background: AppColors.dangerBg,
        foreground: const Color(0xFFB91C1C),
      );
}

/// Green confirmation button (Зберегти зміни).
class SuccessButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const SuccessButton({super.key, required this.text, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) => _ButtonShell(
        text: text,
        onPressed: onPressed,
        icon: icon,
        background: const Color(0xFF4CCB6A),
        foreground: Colors.white,
      );
}

/// Compact gradient pill (e.g. "Змінити" inside an input).
class SmallButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const SmallButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(text,
                style: const TextStyle(
                    color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}

/// White outlined button for third-party sign-in (visual only).
class SocialButton extends StatelessWidget {
  final String text;
  final Widget leading;
  final VoidCallback? onPressed;

  const SocialButton({super.key, required this.text, required this.leading, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Material(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leading,
              const SizedBox(width: 10),
              Text(text,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          ),
        ),
      ),
    );
  }
}
