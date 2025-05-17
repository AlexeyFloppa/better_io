import 'package:flutter/material.dart';

class TextInputDialog extends StatelessWidget {
  final String title;
  final String initialValue;
  final ValueChanged<String> onSave;

  const TextInputDialog({
    Key? key,
    required this.title,
    required this.initialValue,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: initialValue);

    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
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
