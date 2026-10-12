import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Centered, scrollable page used by login / registration / password recovery.
class AuthLayout extends StatelessWidget {
  final Widget? header;
  final Widget child;
  final Widget? footer;
  final double maxWidth;

  const AuthLayout({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.maxWidth = 480,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEEF0FF), AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (header != null) ...[header!, const SizedBox(height: 24)],
                    child,
                    if (footer != null) ...[const SizedBox(height: 24), footer!],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Питання? Дія" line under the card.
class AuthFooterLink extends StatelessWidget {
  final String question;
  final String action;
  final VoidCallback onPressed;

  const AuthFooterLink({
    super.key,
    required this.question,
    required this.action,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(question, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        TextButton(
          onPressed: onPressed,
          child: Text(action,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.accent)),
        ),
      ],
    );
  }
}
