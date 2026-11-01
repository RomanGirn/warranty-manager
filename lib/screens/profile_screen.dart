import 'package:flutter/material.dart';
import '../core/data/mock_data.dart';
import '../core/repositories/auth_repository.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _regDateController;
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();

  String? _photoUrl;
  bool _isSavingProfile = false;
  bool _isUpdatingPassword = false;

  String _language = 'Українська UA';
  int _theme = 0;
  bool _push = true;
  bool _emailReminders = true;
  bool _monthlyReport = false;

  // Набір готових HTTPS-зображень для зміни фото профілю (Завдання 4b)
  static const List<String> _presetAvatars = [
    'https://api.dicebear.com/7.x/avataaars/png?seed=Roman',
    'https://api.dicebear.com/7.x/avataaars/png?seed=Alex',
    'https://api.dicebear.com/7.x/avataaars/png?seed=Sofia',
    'https://api.dicebear.com/7.x/bottts/png?seed=SafeBox1',
    'https://api.dicebear.com/7.x/bottts/png?seed=SafeBox2',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = AuthRepository.instance.currentUser;
    final fullName = (user?.displayName ?? '').trim();
    final parts = fullName.isNotEmpty ? fullName.split(' ') : <String>[];

    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    _firstName = TextEditingController(
      text: firstName.isNotEmpty ? firstName : MockData.firstName,
    );
    _lastName = TextEditingController(
      text: lastName.isNotEmpty
          ? lastName
          : (firstName.isNotEmpty ? '' : MockData.lastName),
    );
    _email = TextEditingController(text: user?.email ?? MockData.email);
    _phone = TextEditingController(
      text: (user?.phoneNumber != null && user!.phoneNumber!.isNotEmpty)
          ? user.phoneNumber!
          : MockData.phone,
    );
    _photoUrl = user?.photoURL;

    final created = user?.metadata.creationTime;
    final formattedDate = created != null
        ? '${created.day.toString().padLeft(2, '0')}.${created.month.toString().padLeft(2, '0')}.${created.year}'
        : MockData.registrationDate;
    _regDateController = TextEditingController(text: formattedDate);
  }

  String get _fullNameDisplay {
    final full = '${_firstName.text.trim()} ${_lastName.text.trim()}'.trim();
    return full.isNotEmpty ? full : 'Користувач';
  }

  String get _initialsDisplay {
    final f = _firstName.text.trim();
    final l = _lastName.text.trim();
    if (f.isNotEmpty && l.isNotEmpty) {
      return '${f[0]}${l[0]}'.toUpperCase();
    } else if (f.isNotEmpty) {
      return f[0].toUpperCase();
    }
    return MockData.initials;
  }

  @override
  void dispose() {
    for (final c in [
      _firstName,
      _lastName,
      _email,
      _phone,
      _regDateController,
      _currentPassword,
      _newPassword,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Модальне вікно вибору фото профілю з готових HTTPS-посилань або власного URL
  Future<void> _showAvatarPickerDialog() async {
    String selectedUrl = _photoUrl ?? _presetAvatars.first;
    final customUrlController = TextEditingController(text: _photoUrl ?? '');

    final chosenUrl = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('Змінити фото профілю'),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.infoBg,
                        backgroundImage: selectedUrl.startsWith('https://')
                            ? NetworkImage(selectedUrl)
                            : null,
                        child: !selectedUrl.startsWith('https://')
                            ? Text(_initialsDisplay,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold))
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Оберіть із готових зображень:',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _presetAvatars.map((url) {
                        final isSelected = selectedUrl == url;
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedUrl = url;
                              customUrlController.text = url;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 26,
                              backgroundColor: AppColors.field,
                              backgroundImage: NetworkImage(url),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: customUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Або введіть власне HTTPS-посилання',
                        hintText: 'https://example.com/avatar.png',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        if (val.trim().startsWith('https://')) {
                          setDialogState(() => selectedUrl = val.trim());
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Скасувати'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final url = customUrlController.text.trim();
                    if (!url.startsWith('https://')) {
                      showAppToast(
                        context,
                        'Посилання має починатися з https://',
                        type: ToastType.error,
                      );
                      return;
                    }
                    Navigator.pop(ctx, url);
                  },
                  child: const Text('Застосувати'),
                ),
              ],
            );
          },
        );
      },
    );

    if (chosenUrl != null && chosenUrl.isNotEmpty) {
      setState(() => _isSavingProfile = true);
      try {
        await AuthRepository.instance.updateProfile(photoUrl: chosenUrl);
        if (!mounted) return;
        setState(() => _photoUrl = chosenUrl);
        showAppToast(context, 'Фото профілю оновлено');
      } catch (e) {
        if (!mounted) return;
        showAppToast(context, e.toString(), type: ToastType.error);
      } finally {
        if (mounted) setState(() => _isSavingProfile = false);
      }
    }
  }

  /// Збереження змін імені та профілю в Firebase Auth
  Future<void> _handleSaveProfile() async {
    if (_isSavingProfile) return;
    if (!_profileFormKey.currentState!.validate()) return;

    setState(() => _isSavingProfile = true);
    try {
      final fullName =
          '${_firstName.text.trim()} ${_lastName.text.trim()}'.trim();
      await AuthRepository.instance.updateProfile(
        displayName: fullName,
        photoUrl: _photoUrl,
      );
      if (!mounted) return;
      setState(() {});
      showAppToast(context, 'Зміни профілю збережено у Firebase');
    } catch (errorMessage) {
      if (!mounted) return;
      showAppToast(context, errorMessage.toString(), type: ToastType.error);
    } finally {
      if (mounted) setState(() => _isSavingProfile = false);
    }
  }

  /// Оновлення пароля користувача через Firebase Auth
  Future<void> _handleUpdatePassword() async {
    if (_isUpdatingPassword) return;
    if (!_passwordFormKey.currentState!.validate()) return;

    setState(() => _isUpdatingPassword = true);
    try {
      await AuthRepository.instance.updatePassword(
        newPassword: _newPassword.text,
        currentPassword: _currentPassword.text,
      );
      if (!mounted) return;
      _currentPassword.clear();
      _newPassword.clear();
      setState(() {});
      showAppToast(
        context,
        'Пароль оновлено',
        subtitle: 'Використовуйте новий пароль під час наступного входу',
      );
    } catch (errorMessage) {
      if (!mounted) return;
      showAppToast(context, errorMessage.toString(), type: ToastType.error);
    } finally {
      if (mounted) setState(() => _isUpdatingPassword = false);
    }
  }

  /// Вихід із сеансу
  Future<void> _handleSignOut() async {
    await AuthRepository.instance.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  /// Видалення акаунту з Firebase
  void _confirmDelete() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Видалити акаунт?'),
        content: const Text(
            'Усі збережені чеки та обліковий запис буде видалено без можливості відновлення.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Скасувати')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await AuthRepository.instance.deleteAccount();
                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (_) => false);
              } catch (e) {
                if (!mounted) return;
                showAppToast(context, e.toString(), type: ToastType.error);
              }
            },
            child: const Text('Видалити',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return AppCard(
      child: Column(
        children: [
          GestureDetector(
            onTap: _showAvatarPickerDialog,
            child: _photoUrl != null && _photoUrl!.startsWith('https://')
                ? Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.infoBg,
                        backgroundImage: NetworkImage(_photoUrl!),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_outlined,
                            size: 16, color: Colors.white),
                      ),
                    ],
                  )
                : UserAvatar(
                    initials: _initialsDisplay, size: 88, showCamera: true),
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 4),
          Text(_fullNameDisplay,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(_email.text,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _personalInfo() {
    return Form(
      key: _profileFormKey,
      child: SectionCard(
        title: 'Персональна інформація',
        icon: Icons.badge_outlined,
        children: [
          FormRow(children: [
            AppTextField(
              label: "Ім'я",
              controller: _firstName,
              onChanged: (_) => setState(() {}),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? "Введіть ім'я" : null,
            ),
            AppTextField(
              label: 'Прізвище',
              controller: _lastName,
              onChanged: (_) => setState(() {}),
            ),
          ]),
          AppTextField(
            label: 'Електронна пошта',
            controller: _email,
            readOnly: true,
          ),
          AppTextField(label: 'Номер телефону', controller: _phone),
          AppTextField(
            label: 'Дата реєстрації',
            controller: _regDateController,
            prefixIcon: Icons.calendar_today_outlined,
            readOnly: true,
            bottomSpacing: 0,
          ),
        ],
      ),
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
          options: const [
            'Українська UA',
            'English EN',
            'Polski PL',
            'Deutsch DE'
          ],
          onChanged: (v) => setState(() => _language = v),
        ),
        SegmentedSelector(
          label: 'Тема оформлення',
          options: const ['Світла', 'Темна', 'Авто'],
          icons: const [
            Icons.light_mode_outlined,
            Icons.dark_mode_outlined,
            Icons.brightness_auto_outlined
          ],
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
    return Form(
      key: _passwordFormKey,
      child: SectionCard(
        title: 'Безпека та пароль',
        icon: Icons.shield_outlined,
        children: [
          AppTextField(
            label: 'Поточний пароль',
            hint: 'Введіть поточний пароль для підтвердження',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            controller: _currentPassword,
            validator: (v) => (v == null || v.isEmpty)
                ? 'Введіть поточний пароль для переавтентифікації'
                : null,
          ),
          AppTextField(
            label: 'Новий пароль',
            hint: 'Введіть новий пароль',
            prefixIcon: Icons.lock_reset,
            isPassword: true,
            controller: _newPassword,
            onChanged: (_) => setState(() {}),
            bottomSpacing: 12,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Введіть новий пароль';
              if (v.length < 8) return 'Мінімум 8 символів';
              return null;
            },
          ),
          PasswordStrengthBar(password: _newPassword.text),
          const SizedBox(height: 12),
          PasswordRequirements(password: _newPassword.text),
          const SizedBox(height: 16),
          SecondaryButton(
            text: _isUpdatingPassword ? 'Оновлення...' : 'Оновити пароль',
            icon: Icons.key,
            onPressed: _isUpdatingPassword ? () {} : _handleUpdatePassword,
          ),
        ],
      ),
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
            onPressed: _handleSignOut,
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
          const PageTitle(
              title: 'Профіль',
              subtitle: 'Керуйте особистими даними та безпекою'),
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
          Row(
            children: [
              Expanded(
                flex: 3,
                child: SuccessButton(
                  text: _isSavingProfile ? 'Збереження...' : 'Зберегти зміни',
                  icon: Icons.save_outlined,
                  onPressed: _isSavingProfile ? () {} : _handleSaveProfile,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SecondaryButton(
                  text: 'Скасувати',
                  onPressed: () {
                    setState(() => _loadUserData());
                    showAppToast(context, 'Зміни скасовано');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
