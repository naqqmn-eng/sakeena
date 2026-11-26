import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_palette.dart';
import '../../../state/counter_controller.dart';

/// اختيار عدد مرات الذكر: قيم جاهزة، أو عدد مخصص.
class TargetSelector extends StatelessWidget {
  const TargetSelector({super.key, required this.target});

  final int target;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isPreset = AppConstants.presetTargets.contains(target);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'عدد المرات',
          style: textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            for (final int value in AppConstants.presetTargets)
              _TargetChip(
                label: '$value',
                selected: target == value,
                onTap: () => _applyTarget(context, value),
              ),
            _TargetChip(
              label: isPreset ? 'مخصص' : '$target',
              selected: !isPreset,
              icon: Icons.edit_outlined,
              onTap: () => _promptCustomTarget(context),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'تغيير العدد يصفّر العدّاد الحالي.',
          style: textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            color: palette.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Future<void> _promptCustomTarget(BuildContext context) async {
    final int? value = await showDialog<int>(
      context: context,
      builder: (BuildContext context) => _CustomTargetDialog(
        initialValue: target,
      ),
    );
    if (value == null || !context.mounted) {
      return;
    }
    await _applyTarget(context, value);
  }

  Future<void> _applyTarget(BuildContext context, int value) async {
    final CounterController counter = context.read<CounterController>();
    if (value == counter.target) {
      return;
    }
    if (counter.count > 0) {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('تغيير عدد المرات؟'),
          content: Text(
            'سيُصفَّر العدّاد الحالي (${counter.count}) ويبدأ من صفر بالعدد '
            'الجديد.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('متابعة'),
            ),
          ],
        ),
      );
      if (confirmed != true) {
        return;
      }
    }
    await counter.setTarget(value);
  }
}

class _TargetChip extends StatelessWidget {
  const _TargetChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      color: selected ? palette.primarySoftColor : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? palette.primaryColor : palette.dividerColor,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(
                  icon,
                  size: 14,
                  color: selected ? palette.primaryColor : palette.secondaryTextColor,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  fontSize: 13,
                  color:
                      selected ? palette.primaryColor : palette.secondaryTextColor,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomTargetDialog extends StatefulWidget {
  const _CustomTargetDialog({required this.initialValue});

  final int initialValue;

  @override
  State<_CustomTargetDialog> createState() => _CustomTargetDialogState();
}

class _CustomTargetDialogState extends State<_CustomTargetDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: '${widget.initialValue}',
  );
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final String raw = _controller.text.trim();
    if (raw.isEmpty) {
      setState(() => _error = 'أدخل عدداً');
      return;
    }
    final int? parsed = int.tryParse(raw);
    if (parsed == null) {
      setState(() => _error = 'عدد غير صالح');
      return;
    }
    if (parsed < AppConstants.minCustomTarget) {
      setState(() => _error = 'يجب أن يكون العدد 1 على الأقل');
      return;
    }
    if (parsed > AppConstants.maxCustomTarget) {
      setState(
        () => _error = 'الحد الأقصى ${AppConstants.maxCustomTarget}',
      );
      return;
    }
    Navigator.of(context).pop(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('عدد مرات مخصص'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        decoration: InputDecoration(
          hintText: 'مثال: 40',
          errorText: _error,
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        TextButton(onPressed: _submit, child: const Text('حفظ')),
      ],
    );
  }
}
