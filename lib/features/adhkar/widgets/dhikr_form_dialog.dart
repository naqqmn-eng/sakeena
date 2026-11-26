import 'package:flutter/material.dart';

/// نتيجة نموذج إضافة/تعديل ذكر مخصص.
class DhikrFormResult {
  const DhikrFormResult({required this.text, this.description});

  final String text;
  final String? description;
}

/// يفتح نموذج إضافة أو تعديل ذكر مخصص، ويعيد النتيجة أو null عند الإلغاء.
Future<DhikrFormResult?> showDhikrFormDialog(
  BuildContext context, {
  String title = 'إضافة ذكر',
  String initialText = '',
  String initialDescription = '',
  String confirmLabel = 'إضافة',
}) {
  return showDialog<DhikrFormResult>(
    context: context,
    builder: (BuildContext context) => _DhikrFormDialog(
      title: title,
      initialText: initialText,
      initialDescription: initialDescription,
      confirmLabel: confirmLabel,
    ),
  );
}

class _DhikrFormDialog extends StatefulWidget {
  const _DhikrFormDialog({
    required this.title,
    required this.initialText,
    required this.initialDescription,
    required this.confirmLabel,
  });

  final String title;
  final String initialText;
  final String initialDescription;
  final String confirmLabel;

  @override
  State<_DhikrFormDialog> createState() => _DhikrFormDialogState();
}

class _DhikrFormDialogState extends State<_DhikrFormDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _textController = TextEditingController(
    text: widget.initialText,
  );
  late final TextEditingController _descriptionController =
      TextEditingController(text: widget.initialDescription);

  @override
  void dispose() {
    _textController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    final String description = _descriptionController.text.trim();
    Navigator.of(context).pop(
      DhikrFormResult(
        text: _textController.text.trim(),
        description: description.isEmpty ? null : description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _textController,
                autofocus: true,
                minLines: 2,
                maxLines: 5,
                maxLength: 1000,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  labelText: 'نص الذكر',
                  hintText: 'اكتب نص الذكر هنا',
                  counterText: '',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'اكتب نص الذكر';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                minLines: 1,
                maxLines: 3,
                maxLength: 300,
                decoration: const InputDecoration(
                  labelText: 'الفضل أو المصدر (اختياري)',
                  counterText: '',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        TextButton(onPressed: _submit, child: Text(widget.confirmLabel)),
      ],
    );
  }
}
