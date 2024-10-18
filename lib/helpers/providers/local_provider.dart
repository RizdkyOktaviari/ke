import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  late Locale _locale = const Locale('id');

  Locale get locale => _locale;

  void toggleLocale() {
    _locale =
        _locale.languageCode == 'id' ? const Locale('id') : const Locale('en');
    notifyListeners();
  }

  void setLocaleByCode(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }
}
