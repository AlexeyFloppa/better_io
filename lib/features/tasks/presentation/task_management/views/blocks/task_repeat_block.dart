import 'package:better_io/features/tasks/presentation/task_management/view_models/block_models/recurrence_block_model.dart';
import 'package:better_io/shared/widgets/tiles/date_picker_tile.dart';
import 'package:better_io/shared/widgets/dialogs/option_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:better_io/features/tasks/presentation/task_management/widgets/duration_picker_dialog.dart';
import 'package:better_io/features/tasks/presentation/task_management/widgets/repeat_days_picker.dart';

class TaskRepeatBlock extends StatelessWidget {
  final RecurrenceBlockModel bm;
  final Color? disabledColor;
  const TaskRepeatBlock({super.key, required this.bm, this.disabledColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
            title: const Text('Repeat'),
            subtitle: const Text(
              'Enable task repetition with customizable options',
            ),
            value: bm.isRepeating,
            onChanged: bm.setRepeating),
        if (bm.isRepeating)
          ListTile(
              title: const Text('Repeat Type:'),
              subtitle: Text(bm.repeatType),
              onTap: () => OptionPickerDialog.show(
                    context,
                    title: 'Repeat Type',
                    options: bm.repeatOptions,
                    selected: bm.repeatType,
                    onSelect: bm.setRepeatType,
                  )),
        if (bm.isRepeating)
          ListTile(
              title: Text('Repeat Interval:'),
              subtitle: Text(bm.repeatInterval.toString()),
              onTap: () => _editInterval(context, bm)),
        if (bm.isRepeating && bm.repeatType == 'Weekly')
          ListTile(
            title: const Text('Select Week Days:'),
            subtitle: Text(_formatRepeatDays('Weekly', bm.weeklyRepeatDays),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => _repeatDaysTile(
                context, 'week', bm.weeklyRepeatDays, bm.setWeeklyRepeatDays),
          ),
        if (bm.isRepeating && bm.repeatType == 'Monthly')
          ListTile(
            title: const Text('Select Month Days:'),
            subtitle: Text(_formatRepeatDays('Monthly', bm.monthlyRepeatDays),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => _repeatDaysTile(context, 'month', bm.monthlyRepeatDays,
                bm.setMonthlyRepeatDays),
          ),
        if (bm.isRepeating && bm.repeatType == 'Yearly')
          ListTile(
            title: const Text('Select Year Days:'),
            subtitle: Text(_formatRepeatDays('Yearly', bm.yearlyRepeatDays),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => _repeatDaysTile(
                context, 'year', bm.yearlyRepeatDays, bm.setYearlyRepeatDays),
          ),
        if (bm.isRepeating)
          ListTile(
            title: const Text('Duration Type:'),
            subtitle: Text(bm.durationType),
            onTap: () => OptionPickerDialog.show(
              context,
              title: 'Duration Type',
              options: ['Forever', 'Until', 'Count'],
              selected: bm.durationType,
              onSelect: bm.setDurationType,
            ),
          ),
        if (bm.isRepeating && bm.durationType == 'Until')
          DatePickerTile(
            title: 'Duration Date:',
            date: bm.durationDate,
            onDateSelected: bm.setDurationDate,
          ),
        if (bm.isRepeating && bm.durationType == 'Count')
          ListTile(
            title: Text('Duration Count:'),
            subtitle: Text(bm.durationCount?.toString() ?? 'Set Count'),
            onTap: () => _editDurationCount(context, bm),
          ),
      ],
    );
  }

  void _editInterval(BuildContext context, RecurrenceBlockModel bm) {
    final controller =
        TextEditingController(text: bm.repeatInterval.toString());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Set Repeat Interval'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration:
              const InputDecoration(hintText: 'Enter interval (e.g., 1, 2, 3)'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              bm.setRepeatInterval(int.tryParse(controller.text) ?? 1);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _repeatDaysTile(BuildContext context, String type, List<int> selected,
      ValueChanged<List<int>> onChanged) {
    showDialog<List<int>>(
      context: context,
      builder: (_) =>
          RepeatDaysPickerDialog(type: type, preselectedDays: selected),
    ).then((v) {
      if (v != null) onChanged(v);
    });
  }

  void _editDurationCount(BuildContext context, RecurrenceBlockModel bm) {
    showDialog(
      context: context,
      builder: (_) => DurationPickerDialog(
        initialCount: bm.durationCount,
        onSave: bm.setDurationCount,
      ),
    );
  }

  String _formatRepeatDays(String type, List<int> selectedDays) {
    if (selectedDays.isEmpty) return 'Empty';
    selectedDays.sort();
    if (type == 'Weekly') {
      const shortDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return selectedDays.map((d) => shortDays[d - 1]).join(', ');
    } else if (type == 'Monthly') {
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
    } else if (type == 'Yearly') {
      return selectedDays.map((day) {
        final date =
            DateTime(DateTime.now().year, 1, 1).add(Duration(days: day - 1));
        return '${DateFormat.MMM().format(date)} ${date.day}';
      }).join(', ');
    }
    return '';
  }
}
