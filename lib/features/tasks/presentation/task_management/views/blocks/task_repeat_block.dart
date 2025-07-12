import 'package:better_io/features/tasks/presentation/task_management/view_models/block_models/recurrence_block_model.dart';
import 'package:better_io/features/tasks/presentation/task_management/widgets/tiles/date_picker_tile.dart';
import 'package:better_io/features/tasks/presentation/task_management/widgets/dialogs/option_picker_dialog.dart';
import 'package:better_io/features/tasks/presentation/task_management/widgets/tiles/input_field_tile.dart';
import 'package:better_io/features/tasks/presentation/task_management/widgets/tiles/repeat_days_tile.dart';
import 'package:better_io/features/tasks/presentation/task_management/widgets/tiles/duration_count_tile.dart';
import 'package:flutter/material.dart';

class TaskRepeatBlock extends StatelessWidget {
  final RecurrenceBlockModel bm;
  const TaskRepeatBlock({super.key, required this.bm});

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
          InputFieldTile(
            title: const Text('Repeat Interval:'),
            value: bm.repeatInterval.toString(),
            onChanged: (value) =>
                bm.setRepeatInterval(int.tryParse(value) ?? bm.repeatInterval),
            dialogTitle: 'Set Repeat Interval',
          ),
        if (bm.isRepeating && bm.repeatType == 'Weekly')
          RepeatDaysTile(
            title: 'Select Week Days:',
            type: 'week',
            selectedDays: bm.weeklyRepeatDays,
            onChanged: bm.setWeeklyRepeatDays,
          ),
        if (bm.isRepeating && bm.repeatType == 'Monthly')
          RepeatDaysTile(
            title: 'Select Month Days:',
            type: 'month',
            selectedDays: bm.monthlyRepeatDays,
            onChanged: bm.setMonthlyRepeatDays,
          ),
        if (bm.isRepeating && bm.repeatType == 'Yearly')
          RepeatDaysTile(
            title: 'Select Year Days:',
            type: 'year',
            selectedDays: bm.yearlyRepeatDays,
            onChanged: bm.setYearlyRepeatDays,
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
            title: const Text('Duration Date:'),
            date: bm.durationDate,
            onDateSelected: bm.setDurationDate,
          ),
        if (bm.isRepeating && bm.durationType == 'Count')
          DurationCountTile(
            title: const Text('Duration Count:'),
            durationCount: bm.durationCount,
            onChanged: bm.setDurationCount,
          ),
      ],
    );
  }
}
