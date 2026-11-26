import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// طبقة تخزين محلية رقيقة فوق [SharedPreferences].
///
/// كل التطبيق يتحدث إلى التخزين من هنا فقط، حتى يسهل استبدال الطبقة لاحقاً
/// بقاعدة بيانات محلية عند إضافة سجل إحصاءات دون لمس بقية الكود.
class PreferencesService {
  PreferencesService(this._prefs);

  final SharedPreferences _prefs;

  static const String keyCounterValue = 'counter.value';
  static const String keySelectedDhikrId = 'counter.selected_dhikr_id';
  static const String keyTarget = 'counter.target';
  static const String keyThemeMode = 'settings.theme_mode';
  static const String keyVibration = 'settings.vibration';
  static const String keyKeepScreenOn = 'settings.keep_screen_on';
  static const String keyCustomAdhkar = 'data.custom_adhkar';

  static Future<PreferencesService> create() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  int getCounterValue() => _prefs.getInt(keyCounterValue) ?? 0;

  Future<void> setCounterValue(int value) async {
    await _prefs.setInt(keyCounterValue, value);
  }

  String? getSelectedDhikrId() => _prefs.getString(keySelectedDhikrId);

  Future<void> setSelectedDhikrId(String id) async {
    await _prefs.setString(keySelectedDhikrId, id);
  }

  int? getTarget() => _prefs.getInt(keyTarget);

  Future<void> setTarget(int target) async {
    await _prefs.setInt(keyTarget, target);
  }

  String? getThemeMode() => _prefs.getString(keyThemeMode);

  Future<void> setThemeMode(String value) async {
    await _prefs.setString(keyThemeMode, value);
  }

  bool getVibration() => _prefs.getBool(keyVibration) ?? true;

  Future<void> setVibration(bool value) async {
    await _prefs.setBool(keyVibration, value);
  }

  bool getKeepScreenOn() => _prefs.getBool(keyKeepScreenOn) ?? false;

  Future<void> setKeepScreenOn(bool value) async {
    await _prefs.setBool(keyKeepScreenOn, value);
  }

  /// الأذكار المخصصة تُخزَّن كنص JSON خام؛ فك الترميز مسؤولية طبقة المستودع.
  String? getCustomAdhkarRaw() => _prefs.getString(keyCustomAdhkar);

  Future<void> setCustomAdhkarRaw(String raw) async {
    await _prefs.setString(keyCustomAdhkar, raw);
  }

  Future<void> removeCustomAdhkar() async {
    await _prefs.remove(keyCustomAdhkar);
  }

  /// أداة صغيرة للتشفير الآمن لمجموعة من الكائنات.
  static String encodeList(List<Map<String, dynamic>> items) =>
      jsonEncode(items);
}
