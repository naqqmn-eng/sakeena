import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../core/services/preferences_service.dart';

/// حالة العدّاد: الذكر المختار، الهدف، والقيمة الحالية.
///
/// القواعد الأساسية هنا وليست في الواجهة:
/// * العدّ يتوقف عند الهدف ولا يتجاوزه أبداً.
/// * تغيير الذكر يصفّر العدّاد.
/// * تغيير الهدف يصفّر العدّاد.
/// كل تغيير يُحفظ فوراً، فلا يضيع العدّ عند إغلاق التطبيق.
class CounterController extends ChangeNotifier {
  CounterController(this._prefs) {
    _selectedDhikrId = _prefs.getSelectedDhikrId();
    _target = _sanitizeTarget(_prefs.getTarget() ?? AppConstants.defaultTarget);
    final int stored = _prefs.getCounterValue();
    _count = stored < 0 ? 0 : (stored > _target ? _target : stored);
  }

  final PreferencesService _prefs;

  String? _selectedDhikrId;
  int _target = AppConstants.defaultTarget;
  int _count = 0;

  String? get selectedDhikrId => _selectedDhikrId;

  int get target => _target;

  int get count => _count;

  bool get isComplete => _count >= _target;

  /// نسبة التقدّم من 0 إلى 1.
  double get progress {
    if (_target <= 0) {
      return 0;
    }
    final double value = _count / _target;
    return value.clamp(0.0, 1.0);
  }

  int get remaining => _target - _count;

  /// يختار ذكراً جديداً ويصفّر العدّاد إن كان الذكر مختلفاً عن الحالي.
  Future<void> selectDhikr(String dhikrId) async {
    if (dhikrId == _selectedDhikrId) {
      return;
    }
    _selectedDhikrId = dhikrId;
    _count = 0;
    notifyListeners();
    await _prefs.setSelectedDhikrId(dhikrId);
    await _prefs.setCounterValue(0);
  }

  /// يضبط الهدف ويصفّر العدّاد. يرمي [ArgumentError] لقيمة غير صالحة.
  Future<void> setTarget(int value) async {
    if (value < AppConstants.minCustomTarget ||
        value > AppConstants.maxCustomTarget) {
      throw ArgumentError.value(value, 'value', 'هدف غير صالح');
    }
    if (value == _target) {
      return;
    }
    _target = value;
    _count = 0;
    notifyListeners();
    await _prefs.setTarget(value);
    await _prefs.setCounterValue(0);
  }

  /// يزيد العدّ بواحد فقط، ويتجاهل الضغط بعد الوصول للهدف.
  Future<void> increment() async {
    if (isComplete) {
      return;
    }
    _count++;
    notifyListeners();
    await _prefs.setCounterValue(_count);
  }

  /// يصفّر العدّاد ويُبقي الذكر والهدف كما هما.
  Future<void> reset() async {
    if (_count == 0) {
      return;
    }
    _count = 0;
    notifyListeners();
    await _prefs.setCounterValue(0);
  }

  static int _sanitizeTarget(int value) {
    if (value < AppConstants.minCustomTarget ||
        value > AppConstants.maxCustomTarget) {
      return AppConstants.defaultTarget;
    }
    return value;
  }
}
