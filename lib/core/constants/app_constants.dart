/// ثوابت التطبيق: النصوص التعريفية، روابط التواصل، والقيم الافتراضية.
class AppConstants {
  const AppConstants._();

  static const String appNameAr = 'سكينة';
  static const String appNameEn = 'Sakeena';

  static const String appTagline = 'أذكار وعداد تسبيح هادئ، يعمل دون اتصال.';

  static const String appDescription =
      'سكينة تطبيق خفيف للأذكار وعدّ التسبيح. يعمل بالكامل دون اتصال '
      'بالإنترنت، لا يحتوي على إعلانات، ولا يجمع أي بيانات عن المستخدم.';

  static const String developerTelegramUsername = 'U_S5S';
  static const String developerTelegramProfileUrl = 'https://t.me/U_S5S';
  static const String developerTelegramChannelUrl =
      'https://t.me/+S2Z-R-55BwQ5NmU8';

  static const String developerName = 'نواف الحديدة';
  static const String copyright = '© 2026 سكينة. جميع الحقوق محفوظة.';

  static const String shareText =
      'جرّب تطبيق سكينة — أذكار وعداد تسبيح هادئ يعمل دون اتصال.\n'
      'قناة التطبيق على تيليجرام: $developerTelegramChannelUrl';

  /// القيم الجاهزة لعدد مرات الذكر.
  static const List<int> presetTargets = <int>[33, 99, 100, 500, 1000];

  static const int defaultTarget = 33;

  /// الحد الأقصى المقبول للهدف المخصص (يمنع القيم العبثية).
  static const int maxCustomTarget = 100000;

  static const int minCustomTarget = 1;
}
