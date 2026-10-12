import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _remember = true;

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      header: Column(
        children: [
          const BrandLogo(size: 56),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Менеджер гарантій',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              SizedBox(width: 8),
              InfoChip(label: 'SafeBox'),
            ],
          ),
        ],
      ),
      footer: AuthFooterLink(
        question: 'Новий користувач?',
        action: 'Зареєструватися',
        onPressed: () => Navigator.pushNamed(context, '/register'),
      ),
      child: AppCard(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Ласкаво просимо назад',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('Увійдіть для доступу до збережених чеків та гарантій',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 28),
            const AppTextField(
              label: 'Електронна пошта',
              hint: 'alex@example.com',
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
            ),
            const AppTextField(
              label: 'Пароль',
              hint: '••••••••••••',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
            ),
            Row(
              children: [
                Expanded(
                  child: LabeledCheckbox(
                    value: _remember,
                    onChanged: (v) => setState(() => _remember = v),
                    label: const Text("Запам'ятати мене", style: TextStyle(fontSize: 13)),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                  child: const Text('Забули пароль?',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              text: 'Увійти',
              icon: Icons.login,
              iconAfter: true,
              // No validation: simply opens the home screen.
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('або увійти через',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 20),
            SocialButton(
              text: 'Продовжити через Google',
              leading: const Text('G',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF4285F4))),
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
          ],
        ),
      ),
    );
  }
}
