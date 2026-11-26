import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_palette.dart';

/// بناء سمت التطبيق (فاتح/داكن) من لوحة ألوان دلالية واحدة.
class AppTheme {
  const AppTheme._();

  static const AppPalette darkPalette = AppPalette(
    primaryColor: Color(0xFF9DAD72),
    backgroundColor: Color(0xFF10120C),
    surfaceColor: Color(0xFF1A1D13),
    textColor: Color(0xFFF1F0E7),
    secondaryTextColor: Color(0xFF9A9D8A),
    dividerColor: Color(0xFF2B2F21),
    primarySoftColor: Color(0x1F9DAD72),
    onPrimaryColor: Color(0xFF14170D),
  );

  static const AppPalette lightPalette = AppPalette(
    primaryColor: Color(0xFF61703F),
    backgroundColor: Color(0xFFF6F5EF),
    surfaceColor: Color(0xFFFFFFFF),
    textColor: Color(0xFF1B1E15),
    secondaryTextColor: Color(0xFF6B6E5E),
    dividerColor: Color(0xFFE2E1D6),
    primarySoftColor: Color(0x1461703F),
    onPrimaryColor: Color(0xFFFFFFFF),
  );

  static ThemeData dark() => _build(darkPalette, Brightness.dark);

  static ThemeData light() => _build(lightPalette, Brightness.light);

  static ThemeData _build(AppPalette palette, Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    final ColorScheme colorScheme = ColorScheme(
      brightness: brightness,
      primary: palette.primaryColor,
      onPrimary: palette.onPrimaryColor,
      secondary: palette.primaryColor,
      onSecondary: palette.onPrimaryColor,
      error: const Color(0xFFB3261E),
      onError: Colors.white,
      surface: palette.surfaceColor,
      onSurface: palette.textColor,
    );

    final TextTheme baseText = isDark
        ? Typography.material2021().white
        : Typography.material2021().black;

    final TextTheme textTheme = baseText.copyWith(
      displayLarge: baseText.displayLarge?.copyWith(
        fontSize: 72,
        fontWeight: FontWeight.w300,
        color: palette.textColor,
        height: 1.05,
      ),
      headlineMedium: baseText.headlineMedium?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: palette.textColor,
      ),
      titleLarge: baseText.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: palette.textColor,
      ),
      titleMedium: baseText.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: palette.textColor,
      ),
      bodyLarge: baseText.bodyLarge?.copyWith(
        fontSize: 16,
        height: 1.6,
        color: palette.textColor,
      ),
      bodyMedium: baseText.bodyMedium?.copyWith(
        fontSize: 14,
        height: 1.6,
        color: palette.secondaryTextColor,
      ),
      labelLarge: baseText.labelLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: palette.textColor,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.backgroundColor,
      canvasColor: palette.backgroundColor,
      dividerColor: palette.dividerColor,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[palette],
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.backgroundColor,
        foregroundColor: palette.textColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.headlineMedium,
      ),
      cardTheme: CardThemeData(
        color: palette.surfaceColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: palette.dividerColor),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surfaceColor,
        surfaceTintColor: Colors.transparent,
        indicatorColor: palette.primarySoftColor,
        elevation: 0,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
          (Set<WidgetState> states) {
            final bool selected = states.contains(WidgetState.selected);
            return textTheme.labelMedium?.copyWith(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color:
                  selected ? palette.primaryColor : palette.secondaryTextColor,
            );
          },
        ),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
          (Set<WidgetState> states) {
            final bool selected = states.contains(WidgetState.selected);
            return IconThemeData(
              size: 24,
              color:
                  selected ? palette.primaryColor : palette.secondaryTextColor,
            );
          },
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primaryColor,
          foregroundColor: palette.onPrimaryColor,
          disabledBackgroundColor: palette.dividerColor,
          disabledForegroundColor: palette.secondaryTextColor,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 17),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textColor,
          side: BorderSide(color: palette.dividerColor),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primaryColor,
          textStyle: textTheme.labelLarge,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? palette.onPrimaryColor
              : palette.secondaryTextColor,
        ),
        trackColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? palette.primaryColor
              : palette.dividerColor,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) => states.contains(WidgetState.selected)
                ? palette.primarySoftColor
                : Colors.transparent,
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) => states.contains(WidgetState.selected)
                ? palette.primaryColor
                : palette.secondaryTextColor,
          ),
          side: WidgetStatePropertyAll<BorderSide>(
            BorderSide(color: palette.dividerColor),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle?>(
            textTheme.labelMedium?.copyWith(fontSize: 13),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.surfaceColor,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: palette.textColor,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surfaceColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyLarge?.copyWith(
          color: palette.secondaryTextColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.backgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: textTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.primaryColor, width: 1.5),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: palette.secondaryTextColor,
        textColor: palette.textColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 4,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.primaryColor,
        linearTrackColor: palette.dividerColor,
        circularTrackColor: palette.dividerColor,
      ),
    );
  }
}
