// lib/providers/theme_provider.dart

import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light; // O tema inicial será o claro

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    // Esta linha é crucial: ela avisa a todos os widgets que "ouvem"
    // que o tema mudou e que eles precisam se redesenhar.
    notifyListeners();
  }
}