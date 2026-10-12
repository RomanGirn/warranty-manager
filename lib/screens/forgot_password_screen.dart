import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      header: const Center(child: BrandLogo(size: 56)),
      footer: AuthFooterLink(
        question: 'Згадали пароль?',
        action: 'Увійти',
        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
      ),
      child: AppCard(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Відновлення пароля',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('Вкажіть e-mail, і ми надішлемо посилання для створення нового пароля',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 28),
            AppTextField(
              label: 'Електронна пошта',
              hint: 'alex@example.com',
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              controller: _email,
            ),
            if (_sent)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.mark_email_read_outlined, color: Color(0xFF047857)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text('Лист із посиланням для відновлення надіслано на вашу пошту.',
                          style: TextStyle(fontSize: 13, color: Color(0xFF065F46))),
                    ),
                  ],
                ),
              ),
            PrimaryButton(
              text: _sent ? 'Надіслати ще раз' : 'Надіслати посилання',
              icon: Icons.send_outlined,
              iconAfter: true,
              // No backend: only shows the success message.
              onPressed: () => setState(() => _sent = true),
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              text: 'Повернутися до входу',
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }
}
