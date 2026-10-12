import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/widgets.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _password = TextEditingController();
  bool _accepted = true;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final score = PasswordRules.score(_password.text);

    return AuthLayout(
      maxWidth: 640,
      header: Row(
        children: [
          const BrandLogo(size: 44),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Створіть акаунт',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                SizedBox(height: 2),
                Text('Приєднайтесь до Менеджера гарантій',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
      footer: AuthFooterLink(
        question: 'Вже маєте акаунт?',
        action: 'Увійти',
        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
      ),
      child: AppCard(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FormRow(children: [
              AppTextField(label: "Ім'я", hint: 'Олександр', prefixIcon: Icons.badge_outlined),
              AppTextField(label: 'Прізвище', hint: 'Коваленко', prefixIcon: Icons.person_outline),
            ]),
            AppTextField(
              label: 'Електронна пошта',
              hint: 'alex@example.com',
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              labelTrailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 7, color: AppColors.accent),
                  SizedBox(width: 4),
                  Text('Вільний e-mail',
                      style: TextStyle(fontSize: 11, color: AppColors.accent)),
                ],
              ),
              suffix: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.check_circle, size: 20, color: AppColors.info),
              ),
            ),
            const AppTextField(
              label: 'Номер телефону',
              hint: '67 123 45 67',
              prefixIcon: Icons.phone_outlined,
              prefixText: '+380',
              keyboardType: TextInputType.phone,
            ),
            AppTextField(
              label: 'Пароль',
              hint: '••••••••••••',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              controller: _password,
              onChanged: (_) => setState(() {}),
              bottomSpacing: 12,
              labelTrailing: Text(
                score == 0 ? '' : '${PasswordRules.label(score)} рівень',
                style: TextStyle(fontSize: 11, color: PasswordRules.color(score)),
              ),
            ),
            PasswordRequirements(password: _password.text),
            const SizedBox(height: 16),
            LabeledCheckbox(
              value: _accepted,
              onChanged: (v) => setState(() => _accepted = v),
              label: const Text('Приймаю умови обслуговування та політику приватності',
                  style: TextStyle(fontSize: 13, color: AppColors.accent)),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Зареєструватися',
              icon: Icons.arrow_forward,
              iconAfter: true,
              // No validation: goes straight to login.
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }
}
