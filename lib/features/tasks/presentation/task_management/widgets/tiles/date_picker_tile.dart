import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerTile extends StatelessWidget {
  final Text title;
  final DateTime? date;
  final ValueChanged<DateTime> onDateSelected;

  const DatePickerTile({
    super.key,
    required this.title,
    required this.date,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: Text(
        date != null ? DateFormat.yMMMd().format(date!) : 'Select a date',
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) onDateSelected(picked);
      },
    );
  }
}
