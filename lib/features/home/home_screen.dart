import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_palette.dart';
import '../../data/models/dhikr.dart';
import '../../shared/widgets/counter_dial.dart';
import '../../state/adhkar_controller.dart';
import '../../state/counter_controller.dart';
import '../../state/settings_controller.dart';
import '../adhkar/widgets/dhikr_picker_sheet.dart';
import 'widgets/target_selector.dart';
import 'widgets/tasbeeh_button.dart';

/// الشاشة الرئيسية: الذكر الحالي، العدّاد، والزر الكبير.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureSelection());
  }

  /// يضمن أن الذكر المحفوظ لا يزال موجوداً (مثلاً بعد حذف ذكر مخصص).
  void _ensureSelection() {
    if (!mounted) {
      return;
    }
    final AdhkarController adhkar = context.read<AdhkarController>();
    final CounterController counter = context.read<CounterController>();
    if (adhkar.byId(counter.selectedDhikrId) == null) {
      counter.selectDhikr(adhkar.first.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final CounterController counter = context.watch<CounterController>();
    final AdhkarController adhkar = context.watch<AdhkarController>();
    final SettingsController settings = context.watch<SettingsController>();
    final Dhikr dhikr = adhkar.byId(counter.selectedDhikrId) ?? adhkar.first;
    final AppPalette palette = AppPalette.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text(
          'سكينة',
          style: textTheme.headlineMedium?.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'تصفير العدّاد',
            onPressed:
                counter.count == 0 ? null : () => _confirmReset(context),
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double dialSize =
                (constraints.maxWidth - 96).clamp(200.0, 304.0).toDouble();
            return Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Column(
                      children: <Widget>[
                        _CurrentDhikrCard(
                          dhikr: dhikr,
                          onTap: () => _pickDhikr(context),
                        ),
                        const SizedBox(height: 28),
                        CounterDial(
                          count: counter.count,
                          target: counter.target,
                          progress: counter.progress,
                          diameter: dialSize,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          counter.isComplete
                              ? 'اكتمل العدد — صفّر العدّاد للبدء من جديد'
                              : 'اضغط الزر بعد كل ذكر',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: counter.isComplete
                                ? palette.primaryColor
                                : palette.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TargetSelector(target: counter.target),
                      const SizedBox(height: 16),
                      TasbeehButton(
                        label: dhikr.counterLabel,
                        completed: counter.isComplete,
                        onTap: () => _onTasbeeh(counter, settings),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _onTasbeeh(
    CounterController counter,
    SettingsController settings,
  ) async {
    if (counter.isComplete) {
      return;
    }
    final bool willComplete = counter.count + 1 >= counter.target;
    if (settings.vibrationEnabled) {
      if (willComplete) {
        await HapticFeedback.mediumImpact();
      } else {
        await HapticFeedback.lightImpact();
      }
    }
    await counter.increment();
  }

  Future<void> _pickDhikr(BuildContext context) async {
    final AdhkarController adhkar = context.read<AdhkarController>();
    final CounterController counter = context.read<CounterController>();
    final String? id = await showDhikrPicker(
      context,
      items: adhkar.items,
      selectedId: counter.selectedDhikrId,
    );
    if (id == null || !mounted) {
      return;
    }
    await counter.selectDhikr(id);
  }

  Future<void> _confirmReset(BuildContext context) async {
    final CounterController counter = context.read<CounterController>();
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('تصفير العدّاد؟'),
        content: const Text(
          'سيُصفَّر العدد الحالي، ويبقى الذكر والهدف والإعدادات كما هي.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('تصفير'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    await counter.reset();
  }
}

class _CurrentDhikrCard extends StatelessWidget {
  const _CurrentDhikrCard({required this.dhikr, required this.onTap});

  final Dhikr dhikr;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      color: palette.surfaceColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 14, 14, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: palette.dividerColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'الذكر الحالي',
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dhikr.text,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        height: 1.8,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.unfold_more_rounded,
                  size: 20,
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
