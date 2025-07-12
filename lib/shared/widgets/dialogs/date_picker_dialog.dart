import 'package:flutter/material.dart';

class DatePickerDialog extends StatefulWidget {
  final String title;
  final DateTime initialDate;
  final ValueChanged<DateTime> onDatePicked;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DatePickerDialog({
    super.key,
    required this.title,
    required this.initialDate,
    required this.onDatePicked,
    this.firstDate,
    this.lastDate,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required DateTime initialDate,
    required ValueChanged<DateTime> onDatePicked,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showDialog(
      context: context,
      builder: (_) => DatePickerDialog(
        title: title,
        initialDate: initialDate,
        onDatePicked: onDatePicked,
        firstDate: firstDate,
        lastDate: lastDate,
      ),
    );
  }

  @override
  State<DatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<DatePickerDialog> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Selected Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: widget.firstDate ?? DateTime(1900),
                lastDate: widget.lastDate ?? DateTime(2100),
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
            child: const Text('Pick Date'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onDatePicked(_selectedDate);
            Navigator.of(context).pop();
          },
          child: const Text('Select'),
        ),
      ],
    );
  }
}
