import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'l10n/messages_all.dart'; // Import the generated file

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode?.isEmpty ?? true
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get welcomeBack {
    return Intl.message(
      'Selamat Datang Kembali!',
      name: 'welcomeBack',
    );
  }

  String get loginToYourAccount {
    return Intl.message(
      'Masuk ke akun Anda',
      name: 'loginToYourAccount',
    );
  }

  String get email {
    return Intl.message(
      'Email',
      name: 'email',
    );
  }

  String get password {
    return Intl.message(
      'Kata Sandi',
      name: 'password',
    );
  }

  String get forgotPassword {
    return Intl.message(
      'Lupa Kata Sandi?',
      name: 'forgotPassword',
    );
  }

  String get login {
    return Intl.message(
      'Masuk',
      name: 'login',
    );
  }

  String get dontHaveAnAccountSignUp {
    return Intl.message(
      'Belum punya akun?, Daftar',
      name: 'dontHaveAnAccountSignUp',
    );
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'id'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
