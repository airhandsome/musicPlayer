import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themePreferenceKey = 'theme_mode';
  final SharedPreferences _preferences;

  ThemeProvider(this._preferences) {
    // 从本地存储加载主题模式
    _themeMode = ThemeMode.values[
        _preferences.getInt(_themePreferenceKey) ?? ThemeMode.system.index];
  }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // 更新主题
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    // 保存到本地存储
    await _preferences.setInt(_themePreferenceKey, mode.index);
    notifyListeners();
  }

  // 切换主题
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }
}
