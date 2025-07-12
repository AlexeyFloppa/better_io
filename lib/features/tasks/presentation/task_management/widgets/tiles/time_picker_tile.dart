import 'package:flutter/material.dart';

class TimePickerTile extends StatelessWidget {
  final Widget title;
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onTimeSelected;
  final bool use24HourFormat;

  const TimePickerTile({
    super.key,
    required this.title,
    required this.time,
    required this.onTimeSelected,
    this.use24HourFormat = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: Text(time.format(context)),
      onTap: () => _selectTime(context),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: time,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(alwaysUse24HourFormat: use24HourFormat),
        child: child!,
      ),
    );
    if (picked != null) {
      onTimeSelected(picked);
    }
  }
}
