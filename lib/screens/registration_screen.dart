import 'package:flutter/material.dart';
import '../core/repositories/auth_repository.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/widgets.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _password = TextEditingController();

  bool _accepted = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_isLoading) return;

    // 1. Локальна валідація полів форми
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_accepted) {
      showAppToast(
        context,
        'Необхідно прийняти умови обслуговування',
        type: ToastType.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final fullName =
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';

      await AuthRepository.instance.signUp(
        email: _emailController.text,
        password: _password.text,
        fullName: fullName,
      );

      if (!mounted) return;
      showAppToast(context, 'Акаунт успішно створено!');
      Navigator.pushReplacementNamed(context, '/home');
    } catch (errorMessage) {
      if (!mounted) return;
      showAppToast(context, errorMessage.toString(), type: ToastType.error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final score = PasswordRules.score(_password.text);

    return AuthLayout(
      maxWidth: 1500,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      headerSpacing: 14,
      footerSpacing: 8,
      header: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9D8FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.verified_user_outlined,
                      size: 11, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 10),
                const Text('Створіть акаунт',
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                const Text('Приєднайтесь до Менеджера гарантій',
                    style: TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 18,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.more_horiz,
                      size: 12, color: AppColors.border),
                ],
              ),
              const SizedBox(height: 9),
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppColors.infoBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lock_outline,
                    size: 14, color: AppColors.accent),
              ),
            ],
          ),
        ],
      ),
      footer: AuthFooterLink(
        question: 'Вже маєте акаунт?',
        action: 'Увійти',
        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FormRow(children: [
                    AppTextField(
                      label: "Ім'я",
                      hint: 'Олександр',
                      prefixIcon: Icons.badge_outlined,
                      controller: _firstNameController,
                      bottomSpacing: 10,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Введіть ім'я";
                        }
                        if (value.trim().length < 2) {
                          return 'Мінімум 2 символи';
                        }
                        return null;
                      },
                    ),
                    AppTextField(
                      label: 'Прізвище',
                      hint: 'Коваленко',
                      prefixIcon: Icons.person_outline,
                      controller: _lastNameController,
                      bottomSpacing: 10,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Введіть прізвище';
                        }
                        return null;
                      },
                    ),
                  ]),
                  AppTextField(
                    label: 'Електронна пошта',
                    hint: 'alex@example.com',
                    prefixIcon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    labelTrailing: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 7, color: AppColors.accent),
                        SizedBox(width: 4),
                        Text('Вільний e-mail',
                            style: TextStyle(
                                fontSize: 11, color: AppColors.accent)),
                      ],
                    ),
                    suffix: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.check_circle,
                          size: 20, color: AppColors.info),
                    ),
                    bottomSpacing: 10,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введіть електронну пошту';
                      }
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Введіть коректний формат e-mail';
                      }
                      return null;
                    },
                  ),
                  AppTextField(
                    label: 'Номер телефону',
                    hint: '67 123 45 67',
                    prefixIcon: Icons.phone_outlined,
                    prefixText: '+380',
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    bottomSpacing: 10,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введіть номер телефону';
                      }
                      final digitsOnly =
                          value.replaceAll(RegExp(r'\D'), '');
                      if (digitsOnly.length != 9) {
                        return 'Введіть 9 цифр номера після +380';
                      }
                      return null;
                    },
                  ),
                  AppTextField(
                    label: 'Пароль',
                    hint: '••••••••••••',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    controller: _password,
                    onChanged: (_) => setState(() {}),
                    bottomSpacing: 8,
                    labelTrailing: Text(
                      score == 0 ? '' : '${PasswordRules.label(score)} рівень',
                      style: TextStyle(
                          fontSize: 11, color: PasswordRules.color(score)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введіть пароль';
                      }
                      if (value.length < 8) {
                        return 'Пароль має містити щонайменше 8 символів';
                      }
                      return null;
                    },
                  ),
                  PasswordRequirements(password: _password.text),
                  const SizedBox(height: 16),
                  LabeledCheckbox(
                    value: _accepted,
                    onChanged: (v) => setState(() => _accepted = v),
                    label: const Text(
                        'Приймаю умови обслуговування та політику приватності',
                        style:
                            TextStyle(fontSize: 13, color: AppColors.accent)),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: _isLoading
                        ? 'Реєстрація...'
                        : 'Зареєструватися',
                    icon: _isLoading ? null : Icons.arrow_forward,
                    iconAfter: true,
                    height: 48,
                    onPressed: _isLoading ? () {} : _handleSignUp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}