import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

import '../../core/theme/app_palette.dart';

/// المؤشر الدائري للعدّ: الحلقة، العدد في المنتصف، والهدف تحته.
class CounterDial extends StatelessWidget {
  const CounterDial({
    super.key,
    required this.count,
    required this.target,
    required this.progress,
    this.diameter = 264,
  });

  final int count;
  final int target;
  final double progress;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'العدد $count من $target',
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.primarySoftColor,
              ),
              child: SizedBox(width: diameter, height: diameter),
            ),
            SizedBox(
              width: diameter - 18,
              height: diameter - 18,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(end: progress),
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                builder: (BuildContext context, double value, Widget? child) {
                  return CircularProgressIndicator(
                    value: value,
                    strokeWidth: 8,
                    strokeCap: StrokeCap.round,
                    backgroundColor: palette.dividerColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      palette.primaryColor,
                    ),
                  );
                },
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (Widget child, Animation<double> anim) {
                    return FadeTransition(
                      opacity: anim,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.94, end: 1).animate(
                          CurvedAnimation(
                            parent: anim,
                            curve: Curves.easeOut,
                          ),
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    '$count',
                    key: ValueKey<int>(count),
                    style: textTheme.displayLarge?.copyWith(
                      fontSize: 64,
                      fontWeight: FontWeight.w300,
                      color: palette.textColor,
                      fontFeatures: const <FontFeature>[
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'من $target',
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
