import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Gradient app logo with a shield icon.
class BrandLogo extends StatelessWidget {
  final double size;
  const BrandLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: const [BoxShadow(color: Color(0x33667EEA), blurRadius: 14, offset: Offset(0, 6))],
      ),
      child: Icon(Icons.verified_user_outlined, color: Colors.white, size: size * 0.55),
    );
  }
}

/// Circle avatar with initials and an optional camera badge.
class UserAvatar extends StatelessWidget {
  final String initials;
  final double size;
  final bool showCamera;

  const UserAvatar({super.key, required this.initials, this.size = 40, this.showCamera = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
          ),
          child: Text(initials,
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700, fontSize: size * 0.3)),
        ),
        if (showCamera)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.photo_camera_outlined, size: 14, color: AppColors.accent),
            ),
          ),
      ],
    );
  }
}
