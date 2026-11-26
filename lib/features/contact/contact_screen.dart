import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_palette.dart';

/// شاشة التواصل مع المطوّر عبر Telegram.
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  static final Uri _tgScheme = Uri(
    scheme: 'tg',
    host: 'resolve',
    queryParameters: <String, String>{
      'domain': AppConstants.developerTelegramUsername,
    },
  );

  static final Uri _profileUri =
      Uri.parse(AppConstants.developerTelegramProfileUrl);

  static final Uri _channelUri =
      Uri.parse(AppConstants.developerTelegramChannelUrl);

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Text('تواصل معنا'),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                decoration: BoxDecoration(
                  color: palette.surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: palette.dividerColor),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: palette.primarySoftColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        size: 28,
                        color: palette.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'نحن هنا لسماعك',
                      style: textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'لأي استفسار أو اقتراح أو ملاحظة حول التطبيق، تواصل '
                      'معنا مباشرة عبر Telegram.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(height: 1.7),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '@${AppConstants.developerTelegramUsername}',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 15,
                        color: palette.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 56,
                child: FilledButton.icon(
                  onPressed: () => _openTelegramProfile(context),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                  label: const Text('تواصل معنا عبر Telegram'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => _openChannel(context),
                  icon: const Icon(Icons.campaign_outlined, size: 20),
                  label: const Text('قناة التطبيق على Telegram'),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'إن لم يفتح Telegram تلقائياً، يمكنك نسخ المعرّف أدناه '
                'وإرسال رسالة لنا يدوياً.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: palette.secondaryTextColor,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton.icon(
                  onPressed: () => _copyUsername(context),
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: const Text('نسخ المعرّف'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openTelegramProfile(BuildContext context) async {
    final bool opened = await _tryLaunch(<Uri>[_tgScheme, _profileUri]);
    if (opened || !context.mounted) {
      return;
    }
    await _offerCopyFallback(context);
  }

  /// رابط قناة الدعوة لا يملك صيغة `tg://resolve`، فيُفتح مباشرة في Telegram
  /// أو المتصفح.
  Future<void> _openChannel(BuildContext context) async {
    final bool opened = await _tryLaunch(<Uri>[_channelUri]);
    if (opened || !context.mounted) {
      return;
    }
    await _offerCopyFallback(context, isChannel: true);
  }

  /// يحاول فتح الروابط بالترتيب، ويعيد true عند نجاح أول واحد.
  static Future<bool> _tryLaunch(List<Uri> uris) async {
    for (final Uri uri in uris) {
      try {
        final bool ok = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (ok) {
          return true;
        }
      } catch (_) {
        // نجرّب البديل التالي.
      }
    }
    return false;
  }

  Future<void> _offerCopyFallback(
    BuildContext context, {
    bool isChannel = false,
  }) async {
    final String display = isChannel
        ? AppConstants.developerTelegramChannelUrl
        : '@${AppConstants.developerTelegramUsername}';
    final bool? copy = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(isChannel ? 'تعذّر فتح القناة' : 'تعذّر فتح Telegram'),
        content: Text(
          isChannel
              ? 'لم نتمكن من فتح قناة التطبيق. يمكنك نسخ رابط القناة '
                  'ولصقه في المتصفح أو في Telegram.'
              : 'لم نتمكن من فتح Telegram على هذا الجهاز. يمكنك نسخ المعرّف '
                  'وإرسال رسالة لنا يدوياً.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إغلاق'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(isChannel ? 'نسخ الرابط' : 'نسخ المعرّف'),
          ),
        ],
      ),
    );
    if (copy != true || !context.mounted) {
      return;
    }
    await Clipboard.setData(ClipboardData(text: display));
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            isChannel
                ? 'نُسخ رابط القناة'
                : 'نُسخ المعرّف @${AppConstants.developerTelegramUsername}',
          ),
        ),
      );
  }

  Future<void> _copyUsername(BuildContext context) async {
    await Clipboard.setData(
      ClipboardData(text: '@${AppConstants.developerTelegramUsername}'),
    );
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'نُسخ المعرّف @${AppConstants.developerTelegramUsername}',
          ),
        ),
      );
  }
}
