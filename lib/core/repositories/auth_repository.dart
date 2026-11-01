import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AuthRepository {
  AuthRepository._();
  static final AuthRepository instance = AuthRepository._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  /// Реєстрація через Email та пароль
  Future<UserCredential> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (fullName != null && fullName.trim().isNotEmpty) {
        await credential.user?.updateDisplayName(fullName.trim());
        await credential.user?.reload();
      }

      await _analytics.logSignUp(signUpMethod: 'email_password');
      return credential;
    } on FirebaseAuthException catch (e, stack) {
      await _recordNonFatalError(e, stack, 'Помилка під час реєстрації');
      throw _mapAuthError(e.code);
    } catch (e, stack) {
      await _recordNonFatalError(e, stack, 'Невідома помилка реєстрації');
      throw 'Не вдалося зареєструватися. Спробуйте пізніше.';
    }
  }

  /// Вхід через Email та пароль
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await _analytics.logLogin(loginMethod: 'email_password');
      return credential;
    } on FirebaseAuthException catch (e, stack) {
      await _recordNonFatalError(e, stack, 'Помилка під час входу');
      throw _mapAuthError(e.code);
    } catch (e, stack) {
      await _recordNonFatalError(e, stack, 'Невідома помилка входу');
      throw 'Не вдалося увійти. Перевірте з\'єднання з мережею.';
    }
  }

  /// Вхід через Google (OAuth) та зв'язування акаунтів за потреби
  Future<UserCredential> signInWithGoogle() async {
    try {
      final googleProvider = GoogleAuthProvider();
      UserCredential credential;

      if (kIsWeb) {
        credential = await _auth.signInWithPopup(googleProvider);
      } else {
        credential = await _auth.signInWithProvider(googleProvider);
      }

      await _analytics.logLogin(loginMethod: 'google');
      return credential;
    } on FirebaseAuthException catch (e, stack) {
      await _recordNonFatalError(e, stack, 'Помилка Google-авторизації');
      throw _mapAuthError(e.code);
    } catch (e, stack) {
      await _recordNonFatalError(e, stack, 'Невідома помилка Google Sign-In');
      throw 'Не вдалося виконати вхід через Google.';
    }
  }

  /// Зв'язування поточного облікового запису з Google-провайдером (Завдання 3b)
  Future<UserCredential> linkGoogleAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw 'Користувач не авторизований.';

    try {
      final googleProvider = GoogleAuthProvider();
      if (kIsWeb) {
        return await user.linkWithPopup(googleProvider);
      } else {
        return await user.linkWithProvider(googleProvider);
      }
    } on FirebaseAuthException catch (e, stack) {
      await _recordNonFatalError(e, stack, 'Помилка прив\'язки Google-акаунту');
      throw _mapAuthError(e.code);
    }
  }

  /// Відновлення пароля через електронну пошту
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      await _analytics.logEvent(name: 'password_reset_requested');
    } on FirebaseAuthException catch (e, stack) {
      await _recordNonFatalError(e, stack, 'Помилка відновлення пароля');
      throw _mapAuthError(e.code);
    }
  }

  /// Оновлення даних профілю (Ім'я та URL фотографії)
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    final user = _auth.currentUser;
    if (user == null) throw 'Сеанс завершено. Увійдіть повторно.';

    try {
      if (displayName != null) {
        await user.updateDisplayName(displayName.trim());
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl.trim());
      }
      await user.reload();
      await _analytics.logEvent(name: 'profile_updated');
    } on FirebaseAuthException catch (e, stack) {
      await _recordNonFatalError(e, stack, 'Помилка оновлення профілю');
      throw _mapAuthError(e.code);
    }
  }

  /// Зміна пароля з підтримкою повторної автентифікації (requires-recent-login)
  Future<void> updatePassword({
    required String newPassword,
    String? currentPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw 'Сеанс завершено. Увійдіть повторно.';

    try {
      if (currentPassword != null &&
          currentPassword.isNotEmpty &&
          user.email != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
      }
      await user.updatePassword(newPassword);
      await _analytics.logEvent(name: 'password_changed');
    } on FirebaseAuthException catch (e, stack) {
      await _recordNonFatalError(e, stack, 'Помилка зміни пароля');
      throw _mapAuthError(e.code);
    }
  }

  /// Вихід із системи
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Видалення акаунту
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw 'Користувач не авторизований.';
    try {
      await user.delete();
      await _analytics.logEvent(name: 'account_deleted');
    } on FirebaseAuthException catch (e, stack) {
      await _recordNonFatalError(e, stack, 'Помилка видалення акаунту');
      throw _mapAuthError(e.code);
    }
}
    
  Future<void> _recordNonFatalError(
    Object error,
    StackTrace stackTrace,
    String reason,
  ) async {
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
      hint: Hint.withMap({'reason': reason}),
    );
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Невірний формат електронної пошти.';
      case 'user-disabled':
        return 'Цей обліковий запис заблоковано.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Не вдалося увійти. Перевірте email і пароль.';
      case 'email-already-in-use':
        return 'Обліковий запис із цією поштою вже існує.';
      case 'weak-password':
        return 'Пароль занадто слабкий (мінімум 6 символів).';
      case 'requires-recent-login':
        return 'З міркувань безпеки потрібно ввести поточний пароль або перезайти в акаунт.';
      case 'credential-already-in-use':
      case 'provider-already-linked':
        return 'Цей спосіб входу вже прив\'язаний до акаунту.';
      case 'too-many-requests':
        return 'Забагато спроб. Зачекайте кілька хвилин і спробуйте знову.';
      case 'network-request-failed':
        return 'Відсутнє підключення до Інтернету.';
      default:
        return 'Помилка авторизації ($code). Спробуйте ще раз.';
    }
  }
}