import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  static const String LOCALE_KEY = 'selected_locale';
  late Locale _locale;

  LocaleProvider() {
    _locale = const Locale('id'); // Default ke bahasa Indonesia
    _loadSavedLocale(); // Load saved locale when initialized
  }

  Locale get locale => _locale;

  // Load saved locale from SharedPreferences
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(LOCALE_KEY);
      if (savedLocale != null) {
        _locale = Locale(savedLocale);
        notifyListeners();
      }
      print('Loaded locale: ${_locale.languageCode}');
    } catch (e) {
      print('Error loading locale: $e');
    }
  }

  // Save and toggle locale
  Future<void> toggleLocale() async {
    try {
      final newLocale = _locale.languageCode == 'id' ? 'en' : 'id';
      _locale = Locale(newLocale);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(LOCALE_KEY, newLocale);

      notifyListeners();
      print('Locale toggled to: $newLocale');
    } catch (e) {
      print('Error toggling locale: $e');
    }
  }

  // Set specific locale and save
  Future<void> setLocaleByCode(String languageCode) async {
    try {
      _locale = Locale(languageCode);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(LOCALE_KEY, languageCode);

      notifyListeners();
      print('Locale set to: $languageCode');
    } catch (e) {
      print('Error setting locale: $e');
    }
  }
}