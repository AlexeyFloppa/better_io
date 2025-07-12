import 'package:flutter/material.dart';

class InputFieldDialog extends StatelessWidget {
  final String title;
  final String initialValue;
  final ValueChanged<String> onSave;
  final TextInputType inputType;

  const InputFieldDialog({
    super.key,
    required this.title,
    required this.initialValue,
    required this.onSave,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: initialValue);

    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: const InputDecoration(hintText: 'Enter value'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onSave(controller.text.isEmpty ? 'Empty' : controller.text);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
