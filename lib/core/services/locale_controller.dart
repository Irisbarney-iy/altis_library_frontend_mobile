import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController {
  static const String _storageKey = 'app_locale_code';

  static final ValueNotifier<Locale> localeNotifier =
      ValueNotifier<Locale>(const Locale('pt'));

  static Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_storageKey);
    if (savedCode != null && savedCode.isNotEmpty) {
      localeNotifier.value = Locale(savedCode);
    }
  }

  static Future<void> setLocale(String languageCode) async {
    localeNotifier.value = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, languageCode);
  }
}