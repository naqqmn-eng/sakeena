import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sakeena/core/services/preferences_service.dart';
import 'package:sakeena/state/settings_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PreferencesService prefs;
  late SettingsController settings;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    prefs = await PreferencesService.create();
    settings = SettingsController(prefs);
  });

  test('الإعدادات الافتراضية: مظهر داكن، اهتزاز مفعّل، الشاشة طبيعية', () {
    expect(settings.themeMode, ThemeMode.dark);
    expect(settings.vibrationEnabled, isTrue);
    expect(settings.keepScreenOn, isFalse);
  });

  test('تغيير المظهر يُحفظ ويُقرأ عند إعادة التشغيل', () async {
    await settings.setThemeMode(ThemeMode.light);

    expect(settings.themeMode, ThemeMode.light);

    final SettingsController restored =
        SettingsController(await PreferencesService.create());
    expect(restored.themeMode, ThemeMode.light);
  });

  test('وضع النظام يُحفظ كقيمة مستقلة', () async {
    await settings.setThemeMode(ThemeMode.system);

    final SettingsController restored =
        SettingsController(await PreferencesService.create());
    expect(restored.themeMode, ThemeMode.system);
  });

  test('إيقاف الاهتزاز يُحفظ', () async {
    await settings.setVibrationEnabled(false);

    expect(settings.vibrationEnabled, isFalse);

    final SettingsController restored =
        SettingsController(await PreferencesService.create());
    expect(restored.vibrationEnabled, isFalse);
  });

  test('تفعيل إبقاء الشاشة مضاءة يُحفظ', () async {
    await settings.setKeepScreenOn(true);

    expect(settings.keepScreenOn, isTrue);

    final SettingsController restored =
        SettingsController(await PreferencesService.create());
    expect(restored.keepScreenOn, isTrue);
  });

  test('قيمة مظهر محفوظة غير معروفة تعود للافتراضي الداكن', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      PreferencesService.keyThemeMode: 'قيمة-غريبة',
    });
    final SettingsController restored =
        SettingsController(await PreferencesService.create());

    expect(restored.themeMode, ThemeMode.dark);
  });

  test('كل تغيير يُعلم المستمعين', () async {
    int notifications = 0;
    settings.addListener(() => notifications++);

    await settings.setThemeMode(ThemeMode.light);
    await settings.setVibrationEnabled(false);
    await settings.setKeepScreenOn(true);

    expect(notifications, 3);
  });

  test('ضبط القيمة نفسها لا يُنشئ إشعاراً ولا كتابة إضافية', () async {
    int notifications = 0;
    settings.addListener(() => notifications++);

    await settings.setThemeMode(ThemeMode.dark);

    expect(notifications, 0);
    expect(prefs.getThemeMode(), isNull);
  });
}
