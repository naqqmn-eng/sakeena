import 'dart:convert';

import '../../core/services/preferences_service.dart';
import '../local/adhkar_seed.dart';
import '../models/dhikr.dart';

/// مصدر واحد لكل الأذكار: المدمجة أولاً ثم المخصصة.
///
/// المدمجة لا تُحذف ولا تُعدَّل أبداً. المخصصة تُحفظ كـ JSON في التخزين المحلي،
/// وأي مدخل تالف يُتجاهل بدل أن يُسقط التطبيق.
class DhikrRepository {
  DhikrRepository(this._prefs);

  final PreferencesService _prefs;

  static const String _customIdPrefix = 'custom_';

  List<Dhikr> loadAll() {
    return <Dhikr>[...AdhkarSeed.builtIn, ..._loadCustom()];
  }

  List<Dhikr> _loadCustom() {
    final String? raw = _prefs.getCustomAdhkarRaw();
    if (raw == null || raw.isEmpty) {
      return const <Dhikr>[];
    }
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! List) {
        return const <Dhikr>[];
      }
      final List<Dhikr> result = <Dhikr>[];
      for (final Object? item in decoded) {
        if (item is Map<String, dynamic>) {
          final Dhikr? dhikr = Dhikr.fromJson(item);
          if (dhikr != null && !dhikr.isBuiltIn) {
            result.add(dhikr);
          }
        } else if (item is Map) {
          final Dhikr? dhikr = Dhikr.fromJson(
            item.map<String, dynamic>(
              (Object? key, Object? value) => MapEntry<String, dynamic>(
                key.toString(),
                value,
              ),
            ),
          );
          if (dhikr != null && !dhikr.isBuiltIn) {
            result.add(dhikr);
          }
        }
      }
      return result;
    } on FormatException {
      return const <Dhikr>[];
    }
  }

  Future<void> _saveCustom(List<Dhikr> custom) async {
    if (custom.isEmpty) {
      await _prefs.removeCustomAdhkar();
      return;
    }
    final String encoded = jsonEncode(
      custom.map((Dhikr dhikr) => dhikr.toJson()).toList(growable: false),
    );
    await _prefs.setCustomAdhkarRaw(encoded);
  }

  /// يضيف ذكراً مخصصاً ويعيده بمعرّفه المولَّد.
  Future<Dhikr> addCustom({
    required String text,
    String? description,
  }) async {
    final List<Dhikr> custom = _loadCustom();
    final Dhikr created = Dhikr(
      id: _generateId(custom),
      text: text.trim(),
      description: _normalizeDescription(description),
      isBuiltIn: false,
    );
    custom.add(created);
    await _saveCustom(custom);
    return created;
  }

  /// يعدّل ذكراً مخصصاً. الأذكار المدمجة لا تُعدَّل وتُرجع كما هي.
  Future<Dhikr> updateCustom({
    required String id,
    required String text,
    String? description,
  }) async {
    final List<Dhikr> custom = _loadCustom();
    final int index = custom.indexWhere((Dhikr dhikr) => dhikr.id == id);
    if (index == -1) {
      return Dhikr(id: id, text: text.trim(), description: description);
    }
    final Dhikr updated = custom[index].copyWith(
      text: text.trim(),
      description: _normalizeDescription(description),
      isBuiltIn: false,
    );
    custom[index] = updated;
    await _saveCustom(custom);
    return updated;
  }

  /// يحذف ذكراً مخصصاً. يعيد false إن لم يكن موجوداً أو كان مدمجاً.
  Future<bool> deleteCustom(String id) async {
    if (id.startsWith('builtin_')) {
      return false;
    }
    final List<Dhikr> custom = _loadCustom();
    final int before = custom.length;
    custom.removeWhere((Dhikr dhikr) => dhikr.id == id);
    if (custom.length == before) {
      return false;
    }
    await _saveCustom(custom);
    return true;
  }

  String? _normalizeDescription(String? value) {
    final String trimmed = (value ?? '').trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _generateId(List<Dhikr> custom) {
    final int stamp = DateTime.now().millisecondsSinceEpoch;
    String candidate = '$_customIdPrefix$stamp';
    int suffix = 0;
    while (custom.any((Dhikr dhikr) => dhikr.id == candidate)) {
      suffix++;
      candidate = '$_customIdPrefix$stamp$suffix';
    }
    return candidate;
  }
}
