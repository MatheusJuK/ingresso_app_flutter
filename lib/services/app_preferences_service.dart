import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesService {
  static const String _darkModeKey = 'dark_mode_enabled';

  static final ValueNotifier<bool> darkModeNotifier = ValueNotifier<bool>(
    false,
  );

  static Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    darkModeNotifier.value = preferences.getBool(_darkModeKey) ?? false;
  }

  static Future<void> toggleDarkMode() async {
    final nextValue = !darkModeNotifier.value;
    darkModeNotifier.value = nextValue;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_darkModeKey, nextValue);
  }
}
