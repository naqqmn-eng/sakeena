import 'package:flutter/foundation.dart';

import '../data/models/dhikr.dart';
import '../data/repositories/dhikr_repository.dart';

/// حالة قائمة الأذكار: المدمجة والمخصصة.
class AdhkarController extends ChangeNotifier {
  AdhkarController(this._repository) : _items = _repository.loadAll();

  final DhikrRepository _repository;

  List<Dhikr> _items;

  List<Dhikr> get items => List<Dhikr>.unmodifiable(_items);

  List<Dhikr> get builtInItems =>
      _items.where((Dhikr dhikr) => dhikr.isBuiltIn).toList(growable: false);

  List<Dhikr> get customItems =>
      _items.where((Dhikr dhikr) => !dhikr.isBuiltIn).toList(growable: false);

  Dhikr? byId(String? id) {
    if (id == null) {
      return null;
    }
    for (final Dhikr dhikr in _items) {
      if (dhikr.id == id) {
        return dhikr;
      }
    }
    return null;
  }

  /// أول ذكر متاح — يُستخدم كاختيار احتياطي.
  Dhikr get first => _items.first;

  Future<Dhikr> addCustom({required String text, String? description}) async {
    final Dhikr created = await _repository.addCustom(
      text: text,
      description: description,
    );
    _items = _repository.loadAll();
    notifyListeners();
    return created;
  }

  Future<void> updateCustom({
    required String id,
    required String text,
    String? description,
  }) async {
    await _repository.updateCustom(
      id: id,
      text: text,
      description: description,
    );
    _items = _repository.loadAll();
    notifyListeners();
  }

  Future<bool> deleteCustom(String id) async {
    final bool removed = await _repository.deleteCustom(id);
    if (removed) {
      _items = _repository.loadAll();
      notifyListeners();
    }
    return removed;
  }
}
