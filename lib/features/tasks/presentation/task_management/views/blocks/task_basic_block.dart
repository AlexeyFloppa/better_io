import 'package:better_io/features/tasks/presentation/task_management/view_models/block_models/basic_block_model.dart';
import 'package:better_io/features/tasks/presentation/task_management/widgets/tiles/color_picker_tile.dart';
import 'package:better_io/features/tasks/presentation/task_management/widgets/tiles/date_picker_tile.dart';
import 'package:better_io/features/tasks/presentation/task_management/widgets/tiles/input_field_tile.dart';
import 'package:better_io/features/tasks/presentation/task_management/widgets/tiles/time_picker_tile.dart';
import 'package:better_io/features/tasks/presentation/task_management/widgets/tiles/option_picker_tile.dart';
import 'package:better_io/features/tasks/domain/entities/task_category.dart';
import 'package:better_io/features/tasks/domain/entities/task_priority.dart';
import 'package:flutter/material.dart';

class TaskBasicBlock extends StatelessWidget {
  final BasicBlockModel bm;
  const TaskBasicBlock({super.key, required this.bm});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputFieldTile(
            title: Text('Name:'), value: bm.name, onChanged: bm.setName),
        InputFieldTile(
            title: Text('Description:'),
            value: bm.description,
            onChanged: bm.setDescription),
        ColorPickerTile(
          title: Text('Color:'),
          color: bm.color,
          onColorChanged: bm.setColor,
        ),
        OptionPickerTile<TaskCategory>(
          title: Text('Category:'),
          selectedValue: bm.category,
          options: bm.categoryOptions,
          dialogTitle: 'Category',
          getLabel: (category) => category.label,
          onSelect: bm.setCategory,
        ),
        OptionPickerTile<TaskPriority>(
          title: Text('Priority:'),
          selectedValue: bm.priority,
          options: bm.priorityOptions,
          dialogTitle: 'Priority',
          getLabel: (priority) => priority.label,
          onSelect: bm.setPriority,
        ),
        DatePickerTile(
          title: const Text('Start Date:'),
          date: bm.startDate,
          onDateSelected: bm.setStartDate,
        ),
        DatePickerTile(
          title: const Text('End Date:'),
          date: bm.endDate,
          onDateSelected: bm.setEndDate,
        ),
        SwitchListTile(
            title: const Text('Time-based task:'),
            subtitle: const Text('Enable to make task tied to time or date'),
            value: bm.isDateTied,
            onChanged: bm.setAllDay),
        if (!bm.isDateTied) ...[
          TimePickerTile(
            title: const Text('Start Time:'),
            time: bm.startTime,
            onTimeSelected: bm.setStartTime,
          ),
          TimePickerTile(
            title: const Text('End Time:'),
            time: bm.endTime,
            onTimeSelected: bm.setEndTime,
          ),
        ]
        else ...[
          ListTile(
            title: const Text('Estimated min duration:'),
            subtitle: Text(
                _formatDuration(bm.minExpectedDuration!)),
          ),
          ListTile(
            title: const Text('Estimated max duration:'),
            subtitle: Text(
                _formatDuration(bm.maxExpectedDuration!)),
          ),
        ],
      ],
    );
  }

  String _formatDuration(Duration d) {
    final days = d.inDays;
    final hours = d.inHours % 24;
    final minutes = d.inMinutes % 60;

    List<String> parts = [];
    if (days > 0) {
      parts.add('$days ${days == 1 ? 'day' : 'days'}');
    }
    if (hours > 0) {
      parts.add('$hours ${hours == 1 ? 'hour' : 'hours'}');
    }
    if (minutes > 0) {
      parts.add('$minutes ${minutes == 1 ? 'minute' : 'minutes'}');
    }

    return parts.isEmpty ? '0 minutes' : parts.join(' and ');
  }

}
