import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_palette.dart';

/// شاشة "حول التطبيق": الاسم، الوصف، الإصدار، والمطوّر.
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late final Future<String?> _version = _readVersion();

  static Future<String?> _readVersion() async {
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      return info.version.isEmpty ? null : info.version;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Text('حول التطبيق'),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: palette.primarySoftColor,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: palette.primaryColor),
                  ),
                  child: Center(
                    child: Text(
                      'س',
                      style: textTheme.headlineMedium?.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: palette.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                AppConstants.appNameAr,
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AppConstants.appTagline,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: palette.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 14),
              FutureBuilder<String?>(
                future: _version,
                builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  final String? version = snapshot.data;
                  return Text(
                    version == null ? '' : 'الإصدار $version',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: palette.secondaryTextColor,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: palette.surfaceColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: palette.dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'عن التطبيق',
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppConstants.appDescription,
                      style: textTheme.bodyMedium?.copyWith(height: 1.8),
                    ),
                    const SizedBox(height: 18),
                    Divider(color: palette.dividerColor, height: 1),
                    const SizedBox(height: 16),
                    _InfoRow(
                      label: 'المطوّر',
                      value: AppConstants.developerName,
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                      label: 'Telegram',
                      value: '@${AppConstants.developerTelegramUsername}',
                      ltr: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppConstants.copyright,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: palette.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.ltr = false,
  });

  final String label;
  final String value;
  final bool ltr;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            fontSize: 13,
            color: palette.secondaryTextColor,
          ),
        ),
        const Spacer(),
        Text(
          value,
          textDirection: ltr ? TextDirection.ltr : null,
          style: textTheme.bodyMedium?.copyWith(
            fontSize: 13,
            color: palette.textColor,
          ),
        ),
      ],
    );
  }
}
