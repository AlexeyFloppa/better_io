// manage_task_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:better_io/features/tasks/domain/usecases/hive/set_hive_task.dart';
import 'package:better_io/features/tasks/data/repositories/hive_task_repository.dart';
import 'package:better_io/shared/widgets/editable_list_tile.dart';
import 'package:better_io/shared/widgets/text_input_dialog.dart';
import 'package:better_io/shared/widgets/color_picker.dart';
import 'package:better_io/features/tasks/presentation/task_management/widgets/duration_picker_dialog.dart';
import 'package:better_io/features/tasks/presentation/task_management/widgets/repeat_days_picker.dart';
import 'package:better_io/features/tasks/presentation/task_management/view_models/manage_task_view_model.dart';

class ManageTaskView extends StatelessWidget {
  final Task? task;
  const ManageTaskView({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final repository = HiveTaskRepository(Hive.box('tasks'));
        final vm = ManageTaskViewModel()
          ..setTaskUseCase(SetHiveTaskUseCase(repository));
        if (task != null) vm.loadFromTask(task!);
        return vm;
      },
      child: const _ManageTaskViewBody(),
    );
  }
}

class _ManageTaskViewBody extends StatelessWidget {
  const _ManageTaskViewBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ManageTaskViewModel>();
    final disabledColor = Theme.of(context)
        .colorScheme
        .onSurface
        .withAlpha((Theme.of(context).colorScheme.onSurface.a * 0.38).round());

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Task')),
      body: ListView(
        children: [
          EditableListTile(
              title: 'Name:',
              subtitle: vm.name,
              onTap: () => _editTextField(context, vm, 'name', vm.name)),
          EditableListTile(
              title: 'Description:',
              subtitle: vm.description,
              onTap: () =>
                  _editTextField(context, vm, 'description', vm.description)),
          EditableListTile(
            title: 'Color:',
            subtitle:
                '#${(vm.color.a.toInt()).toRadixString(16).padLeft(2, '0').toUpperCase()}'
                '${(vm.color.r.toInt()).toRadixString(16).padLeft(2, '0').toUpperCase()}'
                '${(vm.color.g.toInt()).toRadixString(16).padLeft(2, '0').toUpperCase()}'
                '${(vm.color.b.toInt()).toRadixString(16).padLeft(2, '0').toUpperCase()}',
            trailing: CircleAvatar(backgroundColor: vm.color, radius: 15),
            onTap: () => ColorPickerDialog.show(
                context: context,
                initialColor: vm.color,
                onColorPicked: vm.setColor),
          ),
          ListTile(
            title: const Text('Category:'),
            subtitle: Text(vm.category),
            onTap: () => _editDropdown(context, 'Category', vm.categoryOptions,
                vm.category, vm.setCategory),
          ),
          ListTile(
            title: const Text('Priority:'),
            subtitle: Text(vm.priority),
            onTap: () => _editDropdown(context, 'Priority', vm.priorityOptions,
                vm.priority, vm.setPriority),
          ),
          EditableListTile(
              title: 'Start Date:',
              subtitle: DateFormat.yMMMd().format(vm.startDate),
              onTap: () => _selectDate(context, vm.setStartDate, vm.startDate)),
          EditableListTile(
              title: 'End Date:',
              subtitle: DateFormat.yMMMd().format(vm.endDate),
              onTap: () => _selectDate(context, vm.setEndDate, vm.endDate)),
          SwitchListTile(
              title: const Text('All Day'),
              value: vm.isAllDay,
              onChanged: vm.setAllDay),
          ListTile(
            title: const Text('Start Time:'),
            subtitle: Text(vm.startTime.format(context)),
            onTap: vm.isAllDay
                ? null
                : () => _selectTime(context, vm.setStartTime, vm.startTime),
            enabled: !vm.isAllDay,
            textColor: vm.isAllDay ? disabledColor : null,
          ),
          ListTile(
            title: const Text('End Time:'),
            subtitle: Text(vm.endTime.format(context)),
            onTap: vm.isAllDay
                ? null
                : () => _selectTime(context, vm.setEndTime, vm.endTime),
            enabled: !vm.isAllDay,
            textColor: vm.isAllDay ? disabledColor : null,
          ),
          SwitchListTile(
              title: const Text('Repeat'),
              value: vm.isRepeating,
              onChanged: vm.setRepeating),
          if (vm.isRepeating)
            ListTile(
                title: const Text('Repeat Type:'),
                subtitle: Text(vm.repeatType),
                onTap: () => _editDropdown(context, 'Repeat Type',
                    vm.repeatOptions, vm.repeatType, vm.setRepeatType)),
          if (vm.isRepeating)
            EditableListTile(
                title: 'Repeat Interval:',
                subtitle: vm.repeatInterval.toString(),
                onTap: () => _editInterval(context, vm)),
          if (vm.isRepeating && vm.repeatType == 'Weekly')
            ListTile(
              title: const Text('Select Week Days:'),
              subtitle: Text(_formatRepeatDays('Weekly', vm.weeklyRepeatDays),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => _repeatDaysTile(
                  context, 'week', vm.weeklyRepeatDays, vm.setWeeklyRepeatDays),
            ),
          if (vm.isRepeating && vm.repeatType == 'Monthly')
            ListTile(
              title: const Text('Select Month Days:'),
              subtitle: Text(_formatRepeatDays('Monthly', vm.monthlyRepeatDays),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => _repeatDaysTile(context, 'month',
                  vm.monthlyRepeatDays, vm.setMonthlyRepeatDays),
            ),
          if (vm.isRepeating && vm.repeatType == 'Yearly')
            ListTile(
              title: const Text('Select Year Days:'),
              subtitle: Text(_formatRepeatDays('Yearly', vm.yearlyRepeatDays),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => _repeatDaysTile(
                  context, 'year', vm.yearlyRepeatDays, vm.setYearlyRepeatDays),
            ),
          if (vm.isRepeating)
            ListTile(
              title: const Text('Duration Type:'),
              subtitle: Text(vm.durationType),
              onTap: () => _editDropdown(
                  context,
                  'Duration Type',
                  ['Forever', 'Until', 'Count'],
                  vm.durationType,
                  vm.setDurationType),
            ),
          if (vm.isRepeating && vm.durationType == 'Until')
            EditableListTile(
              title: 'Duration Date:',
              subtitle: vm.durationDate != null
                  ? DateFormat.yMMMd().format(vm.durationDate!)
                  : 'Select a date',
              onTap: () => _selectDate(context, vm.setDurationDate,
                  vm.durationDate ?? DateTime.now()),
            ),
          if (vm.isRepeating && vm.durationType == 'Count')
            EditableListTile(
              title: 'Duration Count:',
              subtitle: vm.durationCount?.toString() ?? 'Set Count',
              onTap: () => _editDurationCount(context, vm),
            ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => vm.saveTask(context),
        child: const Icon(Icons.save),
      ),
    );
  }

  void _editTextField(BuildContext context, ManageTaskViewModel vm,
      String title, String value) {
    showDialog(
      context: context,
      builder: (_) => TextInputDialog(
        title: 'Edit $title',
        initialValue: value,
        onSave: (v) => title.toLowerCase() == 'name'
            ? vm.setName(v)
            : vm.setDescription(v),
      ),
    );
  }

  void _editDropdown(BuildContext context, String title, List<String> options,
      String selected, ValueChanged<String> onSelect) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Select $title'),
        content: DropdownButton<String>(
          value: selected,
          isExpanded: true,
          items: options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) {
            if (v != null) onSelect(v);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _editInterval(BuildContext context, ManageTaskViewModel vm) {
    final controller =
        TextEditingController(text: vm.repeatInterval.toString());
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
              vm.setRepeatInterval(int.tryParse(controller.text) ?? 1);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context,
      ValueChanged<DateTime> onSelect, DateTime initial) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) onSelect(picked);
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

  void _editDurationCount(BuildContext context, ManageTaskViewModel vm) {
    showDialog(
      context: context,
      builder: (_) => DurationPickerDialog(
        initialCount: vm.durationCount,
        onSave: vm.setDurationCount,
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
