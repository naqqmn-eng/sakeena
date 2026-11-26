import 'package:flutter/foundation.dart';

/// ذكر واحد: النص، وصف/مصدر اختياري، وهل هو مدمج مع التطبيق أم أضافه المستخدم.
@immutable
class Dhikr {
  const Dhikr({
    required this.id,
    required this.text,
    this.description,
    this.isBuiltIn = false,
    this.actionLabel,
  });

  final String id;
  final String text;
  final String? description;
  final bool isBuiltIn;

  /// نص زر العدّ حين يختلف عن النص الكامل (مثل «سبحان الله» لذكر طويل).
  final String? actionLabel;

  /// النص المختصر المناسب لزر العدّ.
  String get counterLabel {
    final String? label = actionLabel;
    if (label != null && label.isNotEmpty) {
      return label;
    }
    final String trimmed = text.trim();
    if (trimmed.length <= 24) {
      return trimmed;
    }
    return 'تسبيح';
  }

  Dhikr copyWith({
    String? id,
    String? text,
    String? description,
    bool? isBuiltIn,
    String? actionLabel,
  }) {
    return Dhikr(
      id: id ?? this.id,
      text: text ?? this.text,
      description: description ?? this.description,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      actionLabel: actionLabel ?? this.actionLabel,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'description': description,
      'isBuiltIn': isBuiltIn,
      'actionLabel': actionLabel,
    };
  }

  static Dhikr? fromJson(Map<String, dynamic> json) {
    final Object? id = json['id'];
    final Object? text = json['text'];
    if (id is! String || id.isEmpty || text is! String || text.trim().isEmpty) {
      return null;
    }
    final Object? description = json['description'];
    final Object? actionLabel = json['actionLabel'];
    return Dhikr(
      id: id,
      text: text,
      description: description is String ? description : null,
      isBuiltIn: json['isBuiltIn'] == true,
      actionLabel: actionLabel is String ? actionLabel : null,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Dhikr &&
        other.id == id &&
        other.text == text &&
        other.description == description &&
        other.isBuiltIn == isBuiltIn &&
        other.actionLabel == actionLabel;
  }

  @override
  int get hashCode => Object.hash(id, text, description, isBuiltIn, actionLabel);
}
