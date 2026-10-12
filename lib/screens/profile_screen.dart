import 'package:flutter/material.dart';
import '../core/data/mock_data.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firstName = TextEditingController(text: MockData.firstName);
  final _lastName = TextEditingController(text: MockData.lastName);
  final _email = TextEditingController(text: MockData.email);
  final _phone = TextEditingController(text: MockData.phone);
  final _currentPassword = TextEditingController(text: 'password12345');
  final _newPassword = TextEditingController();

  String _language = 'Українська UA';
  int _theme = 0;
  bool _push = true;
  bool _emailReminders = true;
  bool _monthlyReport = false;

  @override
  void dispose() {
    for (final c in [_firstName, _lastName, _email, _phone, _currentPassword, _newPassword]) {
      c.dispose();
    }
    super.dispose();
  }

  void _confirmDelete() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Видалити акаунт?'),
        content: const Text('Усі збережені чеки та гарантії буде видалено без можливості відновлення.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
            },
            child: const Text('Видалити', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return AppCard(
      child: Column(
        children: [
          const UserAvatar(initials: MockData.initials, size: 88, showCamera: true),
          const SizedBox(height: 12),
          const Text(MockData.fullName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          const Text(MockData.email,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _personalInfo() {
    return SectionCard(
      title: 'Персональна інформація',
      icon: Icons.badge_outlined,
      children: [
        FormRow(children: [
          AppTextField(label: "Ім'я", controller: _firstName),
          AppTextField(label: 'Прізвище', controller: _lastName),
        ]),
        AppTextField(
          label: 'Електронна пошта',
          controller: _email,
          suffix: SmallButton(text: 'Змінити', onPressed: () {}),
        ),
        AppTextField(label: 'Номер телефону', controller: _phone),
        AppTextField(
          label: 'Дата реєстрації',
          controller: TextEditingController(text: MockData.registrationDate),
          prefixIcon: Icons.calendar_today_outlined,
          readOnly: true,
          bottomSpacing: 0,
        ),
      ],
    );
  }

  Widget _settings() {
    return SectionCard(
      title: 'Налаштування застосунку',
      icon: Icons.tune,
      children: [
        AppDropdown(
          icon: Icons.language,
          label: 'Мова інтерфейсу',
          value: _language,
          options: const ['Українська UA', 'English EN', 'Polski PL', 'Deutsch DE'],
          onChanged: (v) => setState(() => _language = v),
        ),
        SegmentedSelector(
          label: 'Тема оформлення',
          options: const ['Світла', 'Темна', 'Авто'],
          icons: const [Icons.light_mode_outlined, Icons.dark_mode_outlined, Icons.brightness_auto_outlined],
          selected: _theme,
          onChanged: (i) => setState(() => _theme = i),
        ),
        const Text('Сповіщення та нагадування',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        SettingSwitchTile(
          title: 'Push-сповіщення',
          subtitle: 'Закінчення гарантій та важливі події',
          value: _push,
          onChanged: (v) => setState(() => _push = v),
        ),
        SettingSwitchTile(
          title: 'Email-нагадування',
          subtitle: 'Листи за 30 та 7 днів до фінішу',
          value: _emailReminders,
          onChanged: (v) => setState(() => _emailReminders = v),
        ),
        SettingSwitchTile(
          title: 'Щомісячний звіт',
          subtitle: 'Аналітика та сума витрат на покупки',
          value: _monthlyReport,
          onChanged: (v) => setState(() => _monthlyReport = v),
        ),
      ],
    );
  }

  Widget _security() {
    return SectionCard(
      title: 'Безпека та пароль',
      icon: Icons.shield_outlined,
      children: [
        AppTextField(
          label: 'Поточний пароль',
          hint: 'Введіть поточний пароль',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          controller: _currentPassword,
        ),
        AppTextField(
          label: 'Новий пароль',
          hint: 'Введіть новий пароль',
          prefixIcon: Icons.lock_reset,
          isPassword: true,
          controller: _newPassword,
          onChanged: (_) => setState(() {}),
          bottomSpacing: 12,
        ),
        PasswordStrengthBar(password: _newPassword.text),
        const SizedBox(height: 12),
        PasswordRequirements(password: _newPassword.text),
        const SizedBox(height: 16),
        SecondaryButton(
          text: 'Оновити пароль',
          icon: Icons.key,
          onPressed: () => showAppToast(
            context,
            'Пароль оновлено',
            subtitle: 'Використовуйте новий пароль під час наступного входу',
          ),
        ),
      ],
    );
  }

  Widget _accountActions() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SecondaryButton(
            text: 'Вийти з акаунта',
            icon: Icons.logout,
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false),
          ),
          const SizedBox(height: 12),
          DangerButton(
            text: 'Видалити акаунт назавжди',
            icon: Icons.delete_outline,
            onPressed: _confirmDelete,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const gap = 20.0;
    return AppShell(
      currentIndex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageTitle(title: 'Профіль', subtitle: 'Керуйте особистими даними та безпекою'),
          _header(),
          const SizedBox(height: gap),
          _personalInfo(),
          const SizedBox(height: gap),
          _settings(),
          const SizedBox(height: gap),
          _security(),
          const SizedBox(height: gap),
          _accountActions(),
          const SizedBox(height: gap),
          // Save / cancel sit at the end of the page instead of a floating bar.
          Row(
            children: [
              Expanded(
                flex: 3,
                child: SuccessButton(
                  text: 'Зберегти зміни',
                  icon: Icons.save_outlined,
                  onPressed: () => showAppToast(context, 'Зміни збережено'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SecondaryButton(text: 'Скасувати', onPressed: () {}),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
