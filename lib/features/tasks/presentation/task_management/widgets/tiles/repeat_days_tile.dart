import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:better_io/features/tasks/presentation/task_management/widgets/dialogs/repeat_days_picker_dialog.dart';

class RepeatDaysTile extends StatelessWidget {
  final String title;
  final String type;
  final List<int> selectedDays;
  final ValueChanged<List<int>> onChanged;

  const RepeatDaysTile({
    super.key,
    required this.title,
    required this.type,
    required this.selectedDays,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        _formatRepeatDays(type, selectedDays),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => _showRepeatDaysDialog(context),
    );
  }

  void _showRepeatDaysDialog(BuildContext context) {
    showDialog<List<int>>(
      context: context,
      builder: (_) => RepeatDaysPickerDialog(
        type: type,
        preselectedDays: selectedDays,
      ),
    ).then((v) {
      if (v != null) onChanged(v);
    });
  }

  String _formatRepeatDays(String type, List<int> selectedDays) {
    if (selectedDays.isEmpty) return 'Empty';
    selectedDays.sort();
    if (type == 'week') {
      const shortDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return selectedDays.map((d) => shortDays[d - 1]).join(', ');
    } else if (type == 'month') {
      String suffix(int day) {
        if (day >= 11 && day <= 13) return 'th';
        switch (day % 10) {
          case 1:
            return 'st';
          case 2:
            return 'nd';
          case 3:
            return 'rd';
          default:
            return 'th';
        }
      }

      return selectedDays.map((d) => '$d${suffix(d)}').join(', ');
    } else if (type == 'year') {
      return selectedDays.map((day) {
        final date =
            DateTime(DateTime.now().year, 1, 1).add(Duration(days: day - 1));
        return '${DateFormat.MMM().format(date)} ${date.day}';
      }).join(', ');
    }
    return '';
  }
}
