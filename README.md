# سكينة — Sakeena

تطبيق أذكار وعداد تسبيح هادئ لأندرويد، يعمل بالكامل دون اتصال بالإنترنت. لا حسابات، لا إعلانات، ولا خدمة خلفية: كل شيء يُحفظ على الجهاز.

- **الاسم:** سكينة (Sakeena)
- **معرّف التطبيق:** `com.sakeena.adhkar`
- **اللغة:** العربية، واجهة من اليمين إلى اليسار
- **أقل إصدار مدعوم:** أندرويد 7.0 (API 24)
- **الإصدار الحالي:** 1.0.0

## نظرة عامة

سكينة أداة واحدة بسيطة: عدّاد تسبيح مرتبط بذكر مختار، ومكتبة أذكار مدمجة يمكن التوسّع عليها بأذكارك الخاصة. التصميم هادئ ومينيمالي بهوية زيتونية خفيفة، والوضع الداكن هو الافتراضي.

## المزايا

- **عدّاد تسبيح دائري:** العدّ داخل حلقة تقدّم، والهدف ظاهر دائماً. كل ضغطة تزيد واحداً بالضبط، ويتوقف العد عند الهدف ولا يتجاوزه أبداً.
- **حفظ تلقائي:** العد الحالي، والذكر المختار، والهدف، والأذكار المخصصة، والمظهر، والاهتزاز، وإبقاء الشاشة مضاءة — كلها تبقى بعد إغلاق التطبيق أو إزالته من قائمة التطبيقات أو إعادة تشغيل الجهاز.
- **مكتبة أذكار:** أكثر من عشرين ذكراً مدمجاً شائعاً، مع إمكانية إضافة أذكارك وتعديلها وحذفها. الأذكار المدمجة لا يمكن حذفها.
- **أهداف جاهزة:** 33، 99، 100، 500، 1000، مع هدف مخصص يخضع للتحقق (لا صفر، ولا سالب، ولا نص غير رقمي).
- **إعدادات تعمل فعلياً:** المظهر (النظام/داكن/فاتح)، الاهتزاز، إبقاء الشاشة مضاءة، التواصل مع المطوّر، مشاركة التطبيق، وحول التطبيق.
- **مشاركة عبر نظام أندرويد:** تفتح قائمة المشاركة الأصلية بنص عربي قصير ورابط القناة.
- **بلا أذونات:** لا يطلب التطبيق أي إذن وقت التشغيل، ولا يحتاج اتصالاً بالإنترنت لتشغيله.

## لقطات الشاشة

> مكان مخصص للقطات. أضف الصور إلى `docs/screenshots/` ثم استبدل هذا القسم بها:

| الرئيسية | الأذكار | الإعدادات |
| --- | --- | --- |
| `docs/screenshots/home.png` | `docs/screenshots/adhkar.png` | `docs/screenshots/settings.png` |

## التقنيات

- Flutter (stable) — Dart 3
- Material 3 مع ثيم مخصص و`ThemeExtension` للألوان الدلالية
- `provider` + `ChangeNotifier` لإدارة الحالة
- `shared_preferences` للتخزين المحلي
- `url_launcher` و`share_plus` و`wakelock_plus` و`package_info_plus`

## المتطلبات

- Flutter `3.29.x` (stable) مع Dart `3.7.x`
- Android SDK: `compileSdk 35`، `minSdk 24`، `targetSdk 35`
- JDK 17 (يُستخدم من Gradle وAndroid Studio)
- Gradle 8.10.2 وAGP 8.7.3 (يُداران عبر الـ wrapper المرفق)

## التثبيت والتشغيل

```bash
git clone <repo-url> sakeena
cd sakeena
bash scripts/setup-android.sh   # يجهّز وصف Gradle wrapper مرة واحدة لكل نسخة
flutter pub get
flutter run
```

> ملف `android/gradle/wrapper/gradle-wrapper.properties` يُشحن باسم `gradle-wrapper.properties.example` ليكون رابط توزيعة Gradle قابلاً للمراجعة قبل تفعيله. سكربت `setup-android.sh` ينسخه في مكانه، ولا يستبدل ملفاً موجوداً. خطوة الـ CI تفعل الشيء نفسه تلقائياً.

## بناء APK

```bash
flutter build apk --release
```

الناتج: `build/app/outputs/flutter-apk/app-release.apk` — حزمة **APK واحدة عامة** تحتوي معماريات `arm64-v8a` و`armeabi-v7a` و`x86_64`، بلا تقسيم ABI.

بدون ملف توقيع، يوقّع Gradle الحزمة بمفتاح التصحيح (debug) كي تبقى قابلة للتثبيت للاختبار. هذه الحزمة **ليست نسخة إنتاجية** ولا تصلح للنشر.

## توقيع الإصدار

### محلياً

1. أنشئ مفتاح التوقيع (مرة واحدة، واحتفظ به إلى الأبد):

```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. ضع الملف في `android/app/upload-keystore.jks`.
3. أنشئ `android/key.properties`:

```properties
storePassword=كلمة-مرور-المخزن
keyPassword=كلمة-مرور-المفتاح
keyAlias=upload
storeFile=upload-keystore.jks
```

4. `flutter build apk --release`

`android/key.properties` وملفات `*.jks` مستثناة في `.gitignore` ولا يجوز رفعها إلى مستودع عام.

> **تحذير:** إذا فقدت ملف المفتاح أو كلمة مروره، لن تستطيع إصدار تحديثات موقّعة بنفس الهوية، ولن يقبل متجر Google Play تحديثاً بتوقيع مختلف. احفظ نسخة احتياطية مشفّرة خارج الجهاز.

### عبر GitHub Actions

أضف الأسرار التالية في `Settings → Secrets and variables → Actions`:

| السر | الوصف |
| --- | --- |
| `ANDROID_KEYSTORE_BASE64` | محتوى ملف `upload-keystore.jks` مُرمّزاً بـ Base64 |
| `ANDROID_KEYSTORE_PASSWORD` | كلمة مرور المخزن |
| `ANDROID_KEY_ALIAS` | اسم المفتاح داخل المخزن (مثلاً `upload`) |
| `ANDROID_KEY_PASSWORD` | كلمة مرور المفتاح |

توليد القيمة الأولى:

```bash
base64 upload-keystore.jks > keystore.base64.txt
# macOS: base64 -i upload-keystore.jks -o keystore.base64.txt
# Windows (PowerShell): [Convert]::ToBase64String([IO.File]::ReadAllBytes("upload-keystore.jks")) > keystore.base64.txt
```

ثم انسخ محتوى الملف إلى السر. لا ترفع `keystore.base64.txt` إلى المستودع، واحذفه بعد ذلك.

### ماذا يفعل الـ workflow

`.github/workflows/build.yml` يعمل عند الدفع إلى `main`/`master`، وعند أي Pull Request، ويدوياً عبر `workflow_dispatch`:

1. Checkout
2. Java 17 (Temurin)
3. Flutter 3.29.3 (stable) مع التخزين المؤقت
4. تجهيز وصف Gradle wrapper
5. `flutter pub get`
6. فحص التنسيق `dart format --output=none --set-exit-if-changed` (تحذيري، لا يُسقط البناء)
7. `flutter analyze`
8. `flutter test`
9. فكّ ترميز مفتاح التوقيع وكتابة `android/key.properties` **فقط إذا كانت الأسرار موجودة**
10. `flutter build apk --release`
11. رفع الحزمة كـ artifact

### تنزيل الحزمة

من صفحة التشغيل في تبويب **Actions** → اختر التشغيل → **Artifacts**:

- `sakeena-release-apk` — عند إعداد أسرار التوقيع (حزمة موقّعة بمفتاح الإصدار).
- `sakeena-test-apk-debug-signed` — عند غياب الأسرار (حزمة تجريبية بتوقيع debug، للاختبار فقط).

## الاختبارات

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

تغطي الاختبارات: زيادة العدّاد، التوقف عند الهدف، إعادة التصفير، اختيار ذكر آخر، تغيير الهدف والقيم غير الصالحة، إدارة الأذكار المخصصة، حماية الأذكار المدمجة، التعامل مع بيانات محفوظة تالفة، وحفظ الإعدادات واستعادتها بعد إعادة التشغيل.

## هيكل المشروع

```
lib/
├── main.dart                  نقطة الدخول وتجميع الاعتماديات
├── app.dart                   MaterialApp، الثيم، اللغة، مزامنة سلوك التطبيق
├── core/
│   ├── constants/             ثوابت التطبيق (الاسم، الروابط، النصوص المشتركة)
│   ├── services/              PreferencesService — الغلاف الوحيد حول التخزين
│   ├── theme/                 AppPalette (ThemeExtension) وAppTheme (داكن/فاتح)
│   └── utilities/             أدوات مشتركة
├── data/
│   ├── models/                Dhikr
│   ├── repositories/          DhikrRepository — المدمج + المخصص
│   └── local/                 بيانات الأذكار المدمجة
├── state/
│   ├── counter_controller.dart
│   ├── adhkar_controller.dart
│   └── settings_controller.dart
└── features/
    ├── shell/                 شريط التنقل السفلي
    ├── home/                  العدّاد الدائري
    ├── adhkar/                المكتبة ونموذج الإضافة/التعديل
    ├── settings/
    ├── contact/
    └── about/

android/                       إعدادات أندرويد، الأيقونات، والتوقيع
test/                          اختبارات الوحدة
tool/generate_icons.py         مولّد أيقونات التطبيق (بايثون، بلا اعتماديات)
scripts/setup-android.sh       تجهيز Gradle wrapper
.github/workflows/build.yml    بناء الحزمة والاختبارات
```

## المعمارية

التطبيق مقسّم إلى طبقات: **الواجهة** (`features/`) لا تعرف شيئاً عن التخزين، **الحالة** (`state/`) تنسّق العمليات وتُعلم الواجهة، **البيانات** (`data/`) تحمل النماذج والمستودعات، و**النواة** (`core/`) تضم الثيم والخدمات المشتركة. الاتصال بينها في اتجاه واحد: الواجهة تقرأ الحالة وتستدعي أفعالها، والحالة تكتب عبر `PreferencesService` وحده.

**إدارة الحالة: `provider` مع `ChangeNotifier`.** اخترته لأن التطبيق صغير ومحدود النطاق: لا حاجة إلى توليد كود أو حزم ثقيلة، والوحدات قابلة للاختبار مباشرة (كل وحدة تحكم تُنشأ بمخزن تفضيلات وهمي في الاختبار)، وهو الأسلوب الرسمي المستقر في Flutter. `setState` محصور في الحالة المحلية للواجهة (مثل فتح حوار أو مؤشر مؤقت)، وكل ما يجب أن يبقى بعد إغلاق التطبيق يمر عبر وحدة تحكم.

الألوان تمر عبر `AppPalette` كـ `ThemeExtension` بأسماء دلالية (`primaryColor`، `backgroundColor`، `surfaceColor`، `textColor`، `secondaryTextColor`، `dividerColor`) وليس بأسماء ألوان، لذلك يمكن تغيير الهوية اللونية دون لمس الواجهات.

## التواصل

- Telegram: [@U_S5S](https://t.me/U_S5S)
- القناة: [قناة سكينة على Telegram](https://t.me/+S2Z-R-55BwQ5NmU8)

## حقوق النشر

© 2026 سكينة. جميع الحقوق محفوظة.
