import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_palette.dart';
import '../../state/settings_controller.dart';
import '../about/about_screen.dart';
import '../contact/contact_screen.dart';

/// شاشة الإعدادات: المظهر، الاهتزاز، إبقاء الشاشة مضاءة، والمشاركة والتواصل.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settings = context.watch<SettingsController>();
    final AppPalette palette = AppPalette.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Text('الإعدادات'),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: <Widget>[
            _SectionLabel(text: 'المظهر'),
            _SettingsCard(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'وضع العرض',
                      style: textTheme.titleMedium?.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<ThemeMode>(
                        showSelectedIcon: false,
                        segments: const <ButtonSegment<ThemeMode>>[
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.system,
                            label: Text('النظام'),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.dark,
                            label: Text('داكن'),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.light,
                            label: Text('فاتح'),
                          ),
                        ],
                        selected: <ThemeMode>{settings.themeMode},
                        onSelectionChanged: (Set<ThemeMode> selection) {
                          if (selection.isNotEmpty) {
                            settings.setThemeMode(selection.first);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _SectionLabel(text: 'العدّاد'),
            _SettingsCard(
              child: Column(
                children: <Widget>[
                  SwitchListTile.adaptive(
                    value: settings.vibrationEnabled,
                    onChanged: settings.setVibrationEnabled,
                    title: const Text('الاهتزاز عند العدّ'),
                    subtitle: Text(
                      'اهتزاز خفيف مع كل ضغطة.',
                      style: textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: palette.dividerColor,
                  ),
                  SwitchListTile.adaptive(
                    value: settings.keepScreenOn,
                    onChanged: settings.setKeepScreenOn,
                    title: const Text('إبقاء الشاشة مضاءة'),
                    subtitle: Text(
                      'تمنع إطفاء الشاشة أثناء استخدام العدّاد.',
                      style: textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _SectionLabel(text: 'عن التطبيق'),
            _SettingsCard(
              child: Column(
                children: <Widget>[
                  _NavTile(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'تواصل مع المطوّر',
                    subtitle: 'عبر Telegram',
                    onTap: () => _push(context, const ContactScreen()),
                  ),
                  Divider(
                    height: 1,
                    indent: 56,
                    color: palette.dividerColor,
                  ),
                  _NavTile(
                    icon: Icons.share_outlined,
                    title: 'شارك التطبيق',
                    subtitle: 'أرسل الرابط لقناة التطبيق',
                    onTap: () => _share(context),
                  ),
                  Divider(
                    height: 1,
                    indent: 56,
                    color: palette.dividerColor,
                  ),
                  _NavTile(
                    icon: Icons.info_outline_rounded,
                    title: 'حول التطبيق',
                    subtitle: '${AppConstants.appNameAr} — معلومات التطبيق',
                    onTap: () => _push(context, const AboutScreen()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
  }

  static Future<void> _share(BuildContext context) async {
    try {
      await Share.share(AppConstants.shareText, subject: AppConstants.appNameAr);
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('تعذّر فتح قائمة المشاركة')),
        );
    }
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              letterSpacing: 0.6,
              color: palette.secondaryTextColor,
            ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    return Container(
      decoration: BoxDecoration(
        color: palette.surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.dividerColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, size: 22, color: palette.primaryColor),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontSize: 12, color: palette.secondaryTextColor),
      ),
      trailing: Icon(
        Icons.chevron_left_rounded,
        size: 20,
        color: palette.secondaryTextColor,
      ),
    );
  }
}
