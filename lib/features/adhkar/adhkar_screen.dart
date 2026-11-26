import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_palette.dart';
import '../../data/models/dhikr.dart';
import '../../state/adhkar_controller.dart';
import '../../state/counter_controller.dart';
import 'widgets/dhikr_form_dialog.dart';

/// شاشة الأذكار: تصفّح، اختيار، وإدارة الأذكار المخصصة.
class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({super.key, this.onDhikrSelected});

  /// يُستدعى بعد اختيار ذكر — تستخدمه القشرة للعودة إلى العدّاد.
  final VoidCallback? onDhikrSelected;

  @override
  Widget build(BuildContext context) {
    final AdhkarController adhkar = context.watch<AdhkarController>();
    final CounterController counter = context.watch<CounterController>();
    final List<Dhikr> custom = adhkar.customItems;
    final List<Dhikr> builtIn = adhkar.builtInItems;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Text('الأذكار والعداد'),
        actions: <Widget>[
          IconButton(
            tooltip: 'إضافة ذكر',
            onPressed: () => _addCustom(context),
            icon: const Icon(Icons.add_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: <Widget>[
            _SectionHeader(
              title: 'أذكاري',
              count: custom.length,
            ),
            if (custom.isEmpty)
              const _EmptyCustomHint()
            else
              for (final Dhikr dhikr in custom)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _DhikrTile(
                    dhikr: dhikr,
                    selected: dhikr.id == counter.selectedDhikrId,
                    onTap: () => _select(context, dhikr),
                    onEdit: () => _editCustom(context, dhikr),
                    onDelete: () => _deleteCustom(context, dhikr),
                  ),
                ),
            const SizedBox(height: 20),
            _SectionHeader(
              title: 'الأذكار المدمجة',
              count: builtIn.length,
            ),
            for (final Dhikr dhikr in builtIn)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _DhikrTile(
                  dhikr: dhikr,
                  selected: dhikr.id == counter.selectedDhikrId,
                  onTap: () => _select(context, dhikr),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _select(BuildContext context, Dhikr dhikr) async {
    final CounterController counter = context.read<CounterController>();
    final bool changed = dhikr.id != counter.selectedDhikrId;
    await counter.selectDhikr(dhikr.id);
    if (changed) {
      onDhikrSelected?.call();
    }
  }

  Future<void> _addCustom(BuildContext context) async {
    final AdhkarController adhkar = context.read<AdhkarController>();
    final DhikrFormResult? result = await showDhikrFormDialog(context);
    if (result == null || !context.mounted) {
      return;
    }
    await adhkar.addCustom(
      text: result.text,
      description: result.description,
    );
    if (!context.mounted) {
      return;
    }
    _showMessage(context, 'أُضيف الذكر إلى أذكارك');
  }

  Future<void> _editCustom(BuildContext context, Dhikr dhikr) async {
    final AdhkarController adhkar = context.read<AdhkarController>();
    final DhikrFormResult? result = await showDhikrFormDialog(
      context,
      title: 'تعديل الذكر',
      initialText: dhikr.text,
      initialDescription: dhikr.description ?? '',
      confirmLabel: 'حفظ',
    );
    if (result == null || !context.mounted) {
      return;
    }
    await adhkar.updateCustom(
      id: dhikr.id,
      text: result.text,
      description: result.description,
    );
    if (!context.mounted) {
      return;
    }
    _showMessage(context, 'حُفظ التعديل');
  }

  Future<void> _deleteCustom(BuildContext context, Dhikr dhikr) async {
    final AdhkarController adhkar = context.read<AdhkarController>();
    final CounterController counter = context.read<CounterController>();

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('حذف الذكر؟'),
        content: Text(
          'سيُحذف «${_shorten(dhikr.text)}» من أذكارك المخصصة، ولا يمكن '
          'التراجع عن ذلك.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }

    final bool wasSelected = counter.selectedDhikrId == dhikr.id;
    final bool removed = await adhkar.deleteCustom(dhikr.id);
    if (!removed) {
      return;
    }
    if (wasSelected) {
      await counter.selectDhikr(adhkar.first.id);
    }
    if (!context.mounted) {
      return;
    }
    _showMessage(context, 'حُذف الذكر');
  }

  static String _shorten(String text) {
    final String trimmed = text.trim();
    if (trimmed.length <= 40) {
      return trimmed;
    }
    return '${trimmed.substring(0, 40)}…';
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              color: palette.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCustomHint extends StatelessWidget {
  const _EmptyCustomHint();

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.dividerColor),
      ),
      child: Text(
        'لم تُضف أذكاراً خاصة بعد. استخدم زر الإضافة في الأعلى.',
        style: textTheme.bodyMedium,
      ),
    );
  }
}

class _DhikrTile extends StatelessWidget {
  const _DhikrTile({
    required this.dhikr,
    required this.selected,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final Dhikr dhikr;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool editable = onEdit != null && onDelete != null;

    return Material(
      color: selected ? palette.primarySoftColor : palette.surfaceColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? palette.primaryColor : palette.dividerColor,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      dhikr.text,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        height: 1.75,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: selected ? palette.primaryColor : palette.textColor,
                      ),
                    ),
                    if (dhikr.description != null) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        dhikr.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 4),
              if (editable)
                PopupMenuButton<String>(
                  tooltip: 'خيارات',
                  icon: Icon(
                    Icons.more_vert_rounded,
                    size: 20,
                    color: palette.secondaryTextColor,
                  ),
                  onSelected: (String value) {
                    if (value == 'edit') {
                      onEdit?.call();
                    } else if (value == 'delete') {
                      onDelete?.call();
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      const <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(value: 'edit', child: Text('تعديل')),
                    PopupMenuItem<String>(value: 'delete', child: Text('حذف')),
                  ],
                )
              else if (selected)
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 8),
                  child: Icon(
                    Icons.check_rounded,
                    size: 20,
                    color: palette.primaryColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
