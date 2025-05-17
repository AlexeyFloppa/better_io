import 'package:flutter/material.dart';

class DurationPickerDialog extends StatelessWidget {
  final int? initialAmount;
  final ValueChanged<int> onSave;

  const DurationPickerDialog({
    Key? key,
    required this.initialAmount,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: initialAmount?.toString() ?? '',
    );

    return AlertDialog(
      title: const Text('Set Duration Amount'),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(hintText: 'Enter amount (e.g., 1, 2, 3)'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final int? amount = int.tryParse(controller.text);
            if (amount != null) {
              onSave(amount);
            }
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
