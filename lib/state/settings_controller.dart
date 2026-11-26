import 'package:flutter/material.dart';

import '../core/services/preferences_service.dart';

/// حالة الإعدادات: المظهر، الاهتزاز، وإبقاء الشاشة مضاءة.
///
/// كل تغيير يُحفظ فوراً في التخزين المحلي، فيبقى بعد إغلاق التطبيق وإعادة
/// تشغيل الجهاز.
class SettingsController extends ChangeNotifier {
  SettingsController(this._prefs) {
    _themeMode = _readThemeMode(_prefs.getThemeMode());
    _vibrationEnabled = _prefs.getVibration();
    _keepScreenOn = _prefs.getKeepScreenOn();
  }

  final PreferencesService _prefs;

  late ThemeMode _themeMode;
  late bool _vibrationEnabled;
  late bool _keepScreenOn;

  ThemeMode get themeMode => _themeMode;

  bool get vibrationEnabled => _vibrationEnabled;

  bool get keepScreenOn => _keepScreenOn;

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) {
      return;
    }
    _themeMode = mode;
    notifyListeners();
    await _prefs.setThemeMode(_encodeThemeMode(mode));
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    if (enabled == _vibrationEnabled) {
      return;
    }
    _vibrationEnabled = enabled;
    notifyListeners();
    await _prefs.setVibration(enabled);
  }

  Future<void> setKeepScreenOn(bool enabled) async {
    if (enabled == _keepScreenOn) {
      return;
    }
    _keepScreenOn = enabled;
    notifyListeners();
    await _prefs.setKeepScreenOn(enabled);
  }

  static ThemeMode _readThemeMode(String? raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      case 'dark':
      default:
        return ThemeMode.dark;
    }
  }

  static String _encodeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
      case ThemeMode.dark:
        return 'dark';
    }
  }
}
