import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ToastType { success, error, info }

/// Modern floating notification (replaces the default Material snackbar look).
void showAppToast(
  BuildContext context,
  String message, {
  String? subtitle,
  ToastType type = ToastType.success,
}) {
  final (IconData icon, Color color) = switch (type) {
    ToastType.success => (Icons.check_rounded, AppColors.success),
    ToastType.error => (Icons.error_outline, AppColors.danger),
    ToastType.info => (Icons.info_outline, AppColors.info),
  };

  final screenWidth = MediaQuery.of(context).size.width;
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
      width: screenWidth < 452 ? screenWidth - 32 : 420,
      duration: const Duration(seconds: 3),
      content: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
                color: Color(0x1A111827), blurRadius: 24, offset: Offset(0, 8)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ],
              ),
            ),
            IconButton(
              splashRadius: 18,
              icon: const Icon(Icons.close,
                  size: 18, color: AppColors.textSecondary),
              onPressed: messenger.hideCurrentSnackBar,
            ),
          ],
        ),
      ),
    ),
  );
}
