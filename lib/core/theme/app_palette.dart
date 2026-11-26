import 'package:flutter/material.dart';

/// لوحة الألوان الدلالية للتطبيق.
///
/// الأسماء تصف الدور لا اللون، حتى يمكن تغيير الهوية البصرية دون لمس الواجهات.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.primaryColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.dividerColor,
    required this.primarySoftColor,
    required this.onPrimaryColor,
  });

  /// اللون المميز (الزيتوني الهادئ).
  final Color primaryColor;

  /// خلفية الشاشات.
  final Color backgroundColor;

  /// خلفية البطاقات والأشرطة.
  final Color surfaceColor;

  /// لون النص الأساسي.
  final Color textColor;

  /// لون النص الثانوي والوصف.
  final Color secondaryTextColor;

  /// لون الفواصل والحدود.
  final Color dividerColor;

  /// لون مميز شفاف للخلفيات الخفيفة.
  final Color primarySoftColor;

  /// لون النص فوق اللون المميز.
  final Color onPrimaryColor;

  static AppPalette of(BuildContext context) {
    final AppPalette? palette = Theme.of(context).extension<AppPalette>();
    assert(palette != null, 'AppPalette is not registered in the ThemeData');
    return palette!;
  }

  @override
  AppPalette copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? textColor,
    Color? secondaryTextColor,
    Color? dividerColor,
    Color? primarySoftColor,
    Color? onPrimaryColor,
  }) {
    return AppPalette(
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      textColor: textColor ?? this.textColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      dividerColor: dividerColor ?? this.dividerColor,
      primarySoftColor: primarySoftColor ?? this.primarySoftColor,
      onPrimaryColor: onPrimaryColor ?? this.onPrimaryColor,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) {
      return this;
    }
    return AppPalette(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      secondaryTextColor:
          Color.lerp(secondaryTextColor, other.secondaryTextColor, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      primarySoftColor:
          Color.lerp(primarySoftColor, other.primarySoftColor, t)!,
      onPrimaryColor: Color.lerp(onPrimaryColor, other.onPrimaryColor, t)!,
    );
  }
}
