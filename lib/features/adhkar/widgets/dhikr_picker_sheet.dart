import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../../data/models/dhikr.dart';

/// نافذة سفلية لاختيار ذكر. تعيد معرّف الذكر المختار أو null عند الإلغاء.
Future<String?> showDhikrPicker(
  BuildContext context, {
  required List<Dhikr> items,
  required String? selectedId,
  String title = 'اختيار الذكر',
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppPalette.of(context).surfaceColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.85,
        child: _DhikrPickerSheet(
          items: items,
          selectedId: selectedId,
          title: title,
        ),
      );
    },
  );
}

class _DhikrPickerSheet extends StatelessWidget {
  const _DhikrPickerSheet({
    required this.items,
    required this.selectedId,
    required this.title,
  });

  final List<Dhikr> items;
  final String? selectedId;
  final String title;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: <Widget>[
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: palette.dividerColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 12, 8),
          child: Row(
            children: <Widget>[
              Expanded(child: Text(title, style: textTheme.titleLarge)),
              IconButton(
                tooltip: 'إغلاق',
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        Divider(color: palette.dividerColor, height: 1),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: palette.dividerColor,
              height: 1,
              indent: 20,
              endIndent: 20,
            ),
            itemBuilder: (BuildContext context, int index) {
              final Dhikr dhikr = items[index];
              final bool selected = dhikr.id == selectedId;
              return ListTile(
                onTap: () => Navigator.of(context).pop(dhikr.id),
                title: Text(
                  dhikr.text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    height: 1.8,
                    color: selected ? palette.primaryColor : palette.textColor,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                subtitle: dhikr.description == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          dhikr.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium?.copyWith(fontSize: 12),
                        ),
                      ),
                trailing: Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 20,
                  color:
                      selected ? palette.primaryColor : palette.dividerColor,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
