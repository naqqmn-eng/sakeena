import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'core/constants/app_constants.dart';
import 'core/services/preferences_service.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/dhikr_repository.dart';
import 'features/shell/home_shell.dart';
import 'state/adhkar_controller.dart';
import 'state/counter_controller.dart';
import 'state/settings_controller.dart';

class SakeenaApp extends StatelessWidget {
  const SakeenaApp({super.key, required this.preferences});

  final PreferencesService preferences;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsController>(
          create: (_) => SettingsController(preferences),
        ),
        ChangeNotifierProvider<AdhkarController>(
          create: (_) => AdhkarController(DhikrRepository(preferences)),
        ),
        ChangeNotifierProvider<CounterController>(
          create: (_) => CounterController(preferences),
        ),
      ],
      child: const _SakeenaMaterialApp(),
    );
  }
}

class _SakeenaMaterialApp extends StatelessWidget {
  const _SakeenaMaterialApp();

  @override
  Widget build(BuildContext context) {
    final ThemeMode mode =
        context.select<SettingsController, ThemeMode>((s) => s.themeMode);

    return MaterialApp(
      title: AppConstants.appNameAr,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: mode,
      locale: const Locale('ar'),
      supportedLocales: const <Locale>[Locale('ar'), Locale('en')],
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (BuildContext context, Widget? child) {
        return _AppBehaviorSync(child: child ?? const SizedBox.shrink());
      },
      home: const HomeShell(),
    );
  }
}

/// يطبّق سلوك «إبقاء الشاشة مضاءة» من الإعدادات على مستوى التطبيق.
///
/// التركيب هنا بدل المتحكمات لأنه يعتمد على قناة المنصة ولا يمكن اختباره
/// في اختبارات الوحدة؛ بهذا تبقى المتحكمات قابلة للاختبار بلا قنوات.
class _AppBehaviorSync extends StatefulWidget {
  const _AppBehaviorSync({required this.child});

  final Widget child;

  @override
  State<_AppBehaviorSync> createState() => _AppBehaviorSyncState();
}

class _AppBehaviorSyncState extends State<_AppBehaviorSync> {
  bool? _wakeLockApplied;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool enabled =
        context.select<SettingsController, bool>((s) => s.keepScreenOn);
    if (enabled == _wakeLockApplied) {
      return;
    }
    _wakeLockApplied = enabled;
    _applyWakeLock(enabled);
  }

  Future<void> _applyWakeLock(bool enabled) async {
    try {
      if (enabled) {
        await WakelockPlus.enable();
      } else {
        await WakelockPlus.disable();
      }
    } catch (_) {
      // المنصة غير متاحة (مثلاً في اختبارات الأدوات) — لا شيء نكسره هنا.
    }
  }

  @override
  void dispose() {
    _applyWakeLock(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
