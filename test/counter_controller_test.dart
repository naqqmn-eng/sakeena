import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sakeena/core/constants/app_constants.dart';
import 'package:sakeena/core/services/preferences_service.dart';
import 'package:sakeena/state/counter_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PreferencesService prefs;
  late CounterController counter;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    prefs = await PreferencesService.create();
    counter = CounterController(prefs);
  });

  test('العداد يزيد واحداً في كل مرة', () async {
    await counter.setTarget(5);
    await counter.increment();
    expect(counter.count, 1);
    await counter.increment();
    expect(counter.count, 2);
    expect(counter.progress, closeTo(0.4, 0.0001));
  });

  test('العداد يتوقف عند الهدف ولا يتجاوزه', () async {
    await counter.setTarget(3);
    for (int i = 0; i < 10; i++) {
      await counter.increment();
    }
    expect(counter.count, 3);
    expect(counter.isComplete, isTrue);
    expect(counter.progress, 1.0);
    expect(counter.remaining, 0);
  });

  test('التصفير يعيد العدد إلى صفر ويحتفظ بالذكر والهدف', () async {
    await counter.selectDhikr('builtin_tasbeeh');
    await counter.setTarget(99);
    await counter.increment();
    await counter.increment();
    expect(counter.count, 2);

    await counter.reset();

    expect(counter.count, 0);
    expect(counter.target, 99);
    expect(counter.selectedDhikrId, 'builtin_tasbeeh');
  });

  test('اختيار ذكر مختلف يصفّر العداد', () async {
    await counter.selectDhikr('builtin_tasbeeh');
    await counter.increment();
    expect(counter.count, 1);

    await counter.selectDhikr('builtin_tahmeed');

    expect(counter.count, 0);
    expect(counter.selectedDhikrId, 'builtin_tahmeed');
  });

  test('اختيار الذكر نفسه لا يصفّر العداد', () async {
    await counter.selectDhikr('builtin_tasbeeh');
    await counter.increment();

    await counter.selectDhikr('builtin_tasbeeh');

    expect(counter.count, 1);
  });

  test('تغيير الهدف يصفّر العداد', () async {
    await counter.increment();
    await counter.setTarget(100);

    expect(counter.target, 100);
    expect(counter.count, 0);
  });

  test('الهدف غير الصالح يُرفض', () async {
    await expectLater(counter.setTarget(0), throwsArgumentError);
    await expectLater(counter.setTarget(-5), throwsArgumentError);
    await expectLater(
      counter.setTarget(AppConstants.maxCustomTarget + 1),
      throwsArgumentError,
    );
    expect(counter.target, AppConstants.defaultTarget);
  });

  test('القيمة المحفوظة تبقى بعد إعادة إنشاء المتحكم', () async {
    await counter.selectDhikr('builtin_istighfar');
    await counter.setTarget(100);
    await counter.increment();
    await counter.increment();
    await counter.increment();

    final PreferencesService reloaded = await PreferencesService.create();
    final CounterController restored = CounterController(reloaded);

    expect(restored.count, 3);
    expect(restored.target, 100);
    expect(restored.selectedDhikrId, 'builtin_istighfar');
  });

  test('العدد المحفوظ الأكبر من الهدف يُقصّ إلى الهدف', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      PreferencesService.keyCounterValue: 500,
      PreferencesService.keyTarget: 33,
      PreferencesService.keySelectedDhikrId: 'builtin_tasbeeh',
    });
    final PreferencesService seeded = await PreferencesService.create();
    final CounterController restored = CounterController(seeded);

    expect(restored.count, 33);
    expect(restored.isComplete, isTrue);
  });

  test('الهدف المحفوظ غير الصالح يُستبدل بالافتراضي', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      PreferencesService.keyCounterValue: 4,
      PreferencesService.keyTarget: 0,
    });
    final PreferencesService seeded = await PreferencesService.create();
    final CounterController restored = CounterController(seeded);

    expect(restored.target, AppConstants.defaultTarget);
    expect(restored.count, 4);
  });

  test('المظهر الافتراضي لا يتأثر بحالة العداد', () async {
    // حماية من الخلط بين المتحكمات: العداد لا يكتب مفاتيح الإعدادات.
    await counter.increment();
    expect(prefs.getThemeMode(), isNull);
    expect(prefs.getVibration(), isTrue);
  });
}
