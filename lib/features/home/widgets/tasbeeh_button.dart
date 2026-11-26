import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';

/// زر العدّ الرئيسي — كبير، هادئ، ويتغيّر وضعه عند اكتمال الهدف.
class TasbeehButton extends StatefulWidget {
  const TasbeehButton({
    super.key,
    required this.label,
    required this.completed,
    required this.onTap,
  });

  final String label;
  final bool completed;
  final VoidCallback onTap;

  @override
  State<TasbeehButton> createState() => _TasbeehButtonState();
}

class _TasbeehButtonState extends State<TasbeehButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) {
      return;
    }
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool enabled = !widget.completed;

    final Color background =
        enabled ? palette.primaryColor : palette.surfaceColor;
    final Color foreground =
        enabled ? palette.onPrimaryColor : palette.secondaryTextColor;

    return Semantics(
      button: true,
      enabled: enabled,
      label: enabled ? 'عدّ ${widget.label}' : 'اكتمل العدد',
      child: AnimatedScale(
        scale: _pressed ? 0.975 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(26),
          child: InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: enabled ? widget.onTap : null,
            onTapDown: enabled ? (_) => _setPressed(true) : null,
            onTapUp: enabled ? (_) => _setPressed(false) : null,
            onTapCancel: enabled ? () => _setPressed(false) : null,
            child: Container(
              height: 88,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                border: enabled
                    ? null
                    : Border.all(color: palette.dividerColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    enabled ? Icons.add_rounded : Icons.check_rounded,
                    size: 26,
                    color: foreground,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      enabled ? widget.label : 'اكتمل العدد',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleLarge?.copyWith(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: foreground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
