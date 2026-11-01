import 'package:flutter/material.dart';
import '../core/repositories/auth_repository.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _remember = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await AuthRepository.instance.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;
      showAppToast(context, 'Успішний вхід у систему!');
      Navigator.pushReplacementNamed(context, '/home');
    } catch (errorMessage) {
      if (!mounted) return;
      showAppToast(context, errorMessage.toString(), type: ToastType.error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      await AuthRepository.instance.signInWithGoogle();
      if (!mounted) return;
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
    return AuthLayout(
      maxWidth: 1500,
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Ласкаво просимо назад',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text('Увійдіть для доступу до збережених чеків та гарантій',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 28),
              AppTextField(
                label: 'Електронна пошта',
                hint: 'alex@example.com',
                prefixIcon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введіть електронну пошту';
                  }
                  final emailRegex =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Некоректний формат e-mail';
                  }
                  return null;
                },
              ),
              AppTextField(
                label: 'Пароль',
                hint: '••••••••••••',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введіть пароль';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: LabeledCheckbox(
                      value: _remember,
                      onChanged: (v) => setState(() => _remember = v),
                      label: const Text("Запам'ятати мене",
                          style: TextStyle(fontSize: 13)),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/forgot-password'),
                    child: const Text('Забули пароль?',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: _isLoading ? 'Вхід...' : 'Увійти',
                icon: _isLoading ? null : Icons.login,
                iconAfter: true,
                onPressed: _isLoading ? () {} : _handleSignIn,
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('або увійти через',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.textSecondary)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),
              SocialButton(
                text: 'Продовжити через Google',
                leading: const Text('G',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4285F4))),
                onPressed: _isLoading ? () {} : _handleGoogleSignIn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}