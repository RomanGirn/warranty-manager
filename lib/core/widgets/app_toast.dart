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
        padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x33000000), blurRadius: 24, offset: Offset(0, 8)),
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
                          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12)),
                  ],
                ],
              ),
            ),
            IconButton(
              splashRadius: 18,
              icon: const Icon(Icons.close, size: 18, color: Color(0xFF9CA3AF)),
              onPressed: messenger.hideCurrentSnackBar,
            ),
          ],
        ),
      ),
    ),
  );
}
