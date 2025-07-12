import 'package:better_io/features/tasks/presentation/task_management/view_models/block_models/basic_block_model.dart';
import 'package:better_io/shared/widgets/tiles/date_picker_tile.dart';
import 'package:better_io/shared/widgets/dialogs/option_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:better_io/shared/widgets/dialogs/color_picker_dialog.dart';
import 'package:better_io/shared/widgets/dialogs/text_input_dialog.dart';
import 'package:better_io/features/tasks/domain/entities/task_category.dart';
import 'package:better_io/features/tasks/domain/entities/task_priority.dart';

class TaskBasicBlock extends StatelessWidget {
  final BasicBlockModel bm;
  final Color? disabledColor;
  const TaskBasicBlock({super.key, required this.bm, this.disabledColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            title: Text('Name:'),
            subtitle: Text(bm.name),
            onTap: () => _editTextField(context, bm, 'name', bm.name)),
        ListTile(
            title: Text('Description:'),
            subtitle: Text(bm.description),
            onTap: () =>
                _editTextField(context, bm, 'description', bm.description)),
        ListTile(
          title: Text('Color:'),
          subtitle: Text(
              '#${bm.color.a.toInt().toRadixString(16).padLeft(2, '0').toUpperCase()}'
              '${bm.color.r.toInt().toRadixString(16).padLeft(2, '0').toUpperCase()}'
              '${bm.color.g.toInt().toRadixString(16).padLeft(2, '0').toUpperCase()}'
              '${bm.color.b.toInt().toRadixString(16).padLeft(2, '0').toUpperCase()}'),
          trailing: CircleAvatar(backgroundColor: bm.color, radius: 15),
          onTap: () => ColorPickerDialog.show(
              context: context,
              initialColor: bm.color,
              onColorPicked: bm.setColor),
        ),
        ListTile(
          title: Text('Category:'),
          subtitle: Text(bm.category.label),
          onTap: () => OptionPickerDialog.show(
            context,
            title: 'Category',
            options: bm.categoryOptions.map((e) => e.label).toList(),
            selected: bm.category.label,
            onSelect: (selected) {
              final category =
                  bm.categoryOptions.firstWhere((e) => e.label == selected);
              bm.setCategory(category);
            },
          ),
        ),
        ListTile(
          title: const Text('Priority:'),
          subtitle: Text(bm.priority.label),
          onTap: () => OptionPickerDialog.show(
            context,
            title: 'Priority',
            options: bm.priorityOptions.map((e) => e.label).toList(),
            selected: bm.priority.label,
            onSelect: (selected) {
              final priority =
                  bm.priorityOptions.firstWhere((e) => e.label == selected);
              bm.setPriority(priority);
            },
          ),
        ),
        DatePickerTile(
          title: 'Start Date:',
          date: bm.startDate,
          onDateSelected: bm.setStartDate,
        ),
        DatePickerTile(
          title: 'End Date:',
          date: bm.endDate,
          onDateSelected: bm.setEndDate,
        ),
        SwitchListTile(
            title: const Text('All day:'),
            subtitle: const Text('Enable to make task all-day'),
            value: bm.isAllDay,
            onChanged: bm.setAllDay),
        if (!bm.isAllDay) ...[
          ListTile(
            title: const Text('Start Time:'),
            subtitle: Text(bm.startTime.format(context)),
            onTap: () => _selectTime(context, bm.setStartTime, bm.startTime),
          ),
          ListTile(
            title: const Text('End Time:'),
            subtitle: Text(bm.endTime.format(context)),
            onTap: () => _selectTime(context, bm.setEndTime, bm.endTime),
          ),
        ]
      ],
    );
  }

  void _editTextField(
      BuildContext context, BasicBlockModel bm, String title, String value) {
    showDialog(
      context: context,
      builder: (_) => TextInputDialog(
        title: 'Edit $title',
        initialValue: value,
        onSave: (v) => title.toLowerCase() == 'name'
            ? bm.setName(v)
            : bm.setDescription(v),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context,
      ValueChanged<TimeOfDay> onSelect, TimeOfDay initial) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!),
    );
    if (picked != null) onSelect(picked);
  }
}
