import 'package:flutter/material.dart';

class OptionPickerDialog extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  const OptionPickerDialog({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelect,
  }) {
    return showDialog(
      context: context,
      builder: (_) => OptionPickerDialog(
        title: title,
        options: options,
        selected: selected,
        onSelect: onSelect,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select $title'),
      content: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: 400), // Optional: limit max width
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            return ListTile(
              title: Text(option),
              selected: option == selected,
              onTap: () {
                onSelect(option);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
