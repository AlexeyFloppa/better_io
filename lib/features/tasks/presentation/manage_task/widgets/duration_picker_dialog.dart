import 'package:flutter/material.dart';

class DurationPickerDialog extends StatelessWidget {
  final int? initialCount;
  final ValueChanged<int> onSave;

  const DurationPickerDialog({
    super.key,
    required this.initialCount,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: initialCount?.toString() ?? '',
    );

    return AlertDialog(
      title: const Text('Set Duration Count'),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration:
            const InputDecoration(hintText: 'Enter Count (e.g., 1, 2, 3)'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final int? Count = int.tryParse(controller.text);
            if (Count != null) {
              onSave(Count);
            }
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
