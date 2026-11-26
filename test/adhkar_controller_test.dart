import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sakeena/core/services/preferences_service.dart';
import 'package:sakeena/data/models/dhikr.dart';
import 'package:sakeena/data/repositories/dhikr_repository.dart';
import 'package:sakeena/state/adhkar_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PreferencesService prefs;
  late AdhkarController adhkar;

  Future<AdhkarController> reload() async {
    final PreferencesService fresh = await PreferencesService.create();
    return AdhkarController(DhikrRepository(fresh));
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    prefs = await PreferencesService.create();
    adhkar = AdhkarController(DhikrRepository(prefs));
  });

  test('الأذكار المدمجة محمّلة وعددها أكثر من عشرين', () {
    expect(adhkar.builtInItems.length, greaterThan(20));
    expect(adhkar.customItems, isEmpty);
    expect(adhkar.items.length, adhkar.builtInItems.length);
    for (final Dhikr dhikr in adhkar.builtInItems) {
      expect(dhikr.isBuiltIn, isTrue);
      expect(dhikr.text.trim(), isNotEmpty);
    }
  });

  test('معرّفات الأذكار المدمجة فريدة', () {
    final Set<String> ids =
        adhkar.builtInItems.map((Dhikr dhikr) => dhikr.id).toSet();
    expect(ids.length, adhkar.builtInItems.length);
  });

  test('إضافة ذكر مخصص تظهر في القائمة وتُحفظ', () async {
    final Dhikr created = await adhkar.addCustom(
      text: 'سبحان الله وبحمده',
      description: 'تُقال مئة مرة',
    );

    expect(created.isBuiltIn, isFalse);
    expect(adhkar.customItems.length, 1);
    expect(adhkar.byId(created.id)?.text, 'سبحان الله وبحمده');

    final AdhkarController restored = await reload();
    expect(restored.customItems.length, 1);
    expect(restored.byId(created.id)?.description, 'تُقال مئة مرة');
  });

  test('تعديل ذكر مخصص يحدّث النص ويبقى بعد إعادة التحميل', () async {
    final Dhikr created = await adhkar.addCustom(text: 'ذكر قديم');

    await adhkar.updateCustom(
      id: created.id,
      text: 'ذكر جديد',
      description: 'مصدر',
    );

    expect(adhkar.byId(created.id)?.text, 'ذكر جديد');
    final AdhkarController restored = await reload();
    expect(restored.byId(created.id)?.text, 'ذكر جديد');
    expect(restored.byId(created.id)?.description, 'مصدر');
  });

  test('حذف ذكر مخصص يزيله نهائياً', () async {
    final Dhikr created = await adhkar.addCustom(text: 'ذكر للحذف');

    final bool removed = await adhkar.deleteCustom(created.id);

    expect(removed, isTrue);
    expect(adhkar.byId(created.id), isNull);
    expect(adhkar.customItems, isEmpty);

    final AdhkarController restored = await reload();
    expect(restored.byId(created.id), isNull);
  });

  test('الأذكار المدمجة لا تُحذف', () async {
    final Dhikr builtIn = adhkar.builtInItems.first;

    final bool removed = await adhkar.deleteCustom(builtIn.id);

    expect(removed, isFalse);
    expect(adhkar.byId(builtIn.id), isNotNull);
  });

  test('الأذكار المدمجة لا تتأثر بتعديل مخصص بمعرّف مدمج', () async {
    final Dhikr builtIn = adhkar.builtInItems.first;
    final String originalText = builtIn.text;

    await adhkar.updateCustom(id: builtIn.id, text: 'نص مزيف');

    expect(adhkar.byId(builtIn.id)?.text, originalText);
  });

  test('بيانات محفوظة تالفة لا تُسقط التطبيق', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      PreferencesService.keyCustomAdhkar: '{ليست JSON صالحة',
    });
    final AdhkarController broken = await reload();

    expect(broken.builtInItems.length, greaterThan(20));
    expect(broken.customItems, isEmpty);
  });

  test('عناصر محفوظة غير صالحة تُتجاهل ويبقى الصالح', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      PreferencesService.keyCustomAdhkar:
          '[{"id":"custom_1","text":"صالح"},{"id":"","text":"بلا معرّف"},'
              '{"foo":"bar"},42]',
    });
    final AdhkarController restored = await reload();

    expect(restored.customItems.length, 1);
    expect(restored.customItems.first.text, 'صالح');
  });

  test('كل ذكر من الأذكار المدمجة له تسمية زر غير فارغة', () {
    for (final Dhikr dhikr in adhkar.builtInItems) {
      expect(dhikr.counterLabel.trim(), isNotEmpty);
    }
  });
}
