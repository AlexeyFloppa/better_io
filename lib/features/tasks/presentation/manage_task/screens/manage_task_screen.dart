import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:better_io/features/tasks/data/repositories/hive_task_repository.dart';
import 'package:hive/hive.dart';
import 'package:better_io/features/tasks/presentation/manage_task/widgets/repeat_days_picker.dart';
import 'package:better_io/features/tasks/domain/usecases/hive/set_hive_task.dart';
import 'package:better_io/features/tasks/presentation/manage_task/widgets/duration_picker_dialog.dart';
import 'package:better_io/features/tasks/presentation/manage_task/widgets/editable_list_tile.dart';
import 'package:better_io/features/tasks/presentation/manage_task/widgets/text_input_dialog.dart';
import 'package:provider/provider.dart';
import 'package:better_io/features/tasks/presentation/manage_task/view_models/manage_task_view_model.dart';

class ManageTaskScreen extends StatelessWidget {
  const ManageTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ManageTaskViewModel(),
      child: const _ManageTaskScreenBody(),
    );
  }
}

class _ManageTaskScreenBody extends StatefulWidget {
  const _ManageTaskScreenBody();

  @override
  State<_ManageTaskScreenBody> createState() => _ManageTaskScreenBodyState();
}

class _ManageTaskScreenBodyState extends State<_ManageTaskScreenBody> {
  late final SetHiveTaskUseCase _setTaskUseCase;

  @override
  void initState() {
    super.initState();
    final taskRepository = HiveTaskRepository(Hive.box('tasks'));
    _setTaskUseCase = SetHiveTaskUseCase(taskRepository);
  }

  Future<void> _saveTask(BuildContext context, ManageTaskViewModel vm) async {
    String? recurrenceRule;
    if (vm.isRepeating) {
      const weekdayMap = {
        1: 'MO',
        2: 'TU',
        3: 'WE',
        4: 'TH',
        5: 'FR',
        6: 'SA',
        7: 'SU',
      };

      List<String> parts = [
        'FREQ=${vm.repeatType.toUpperCase()}',
        'INTERVAL=${vm.repeatInterval}',
      ];

      if (vm.repeatType == 'Weekly') {
        parts.add(
            'BYDAY=${vm.weeklyRepeatDays.map((d) => weekdayMap[d]!).join(',')}');
      } else if (vm.repeatType == 'Monthly') {
        parts.add('BYMONTHDAY=${vm.monthlyRepeatDays.join(',')};');
      } else if (vm.repeatType == 'Yearly') {
        parts.add('BYYEARDAY=${vm.yearlyRepeatDays.join(',')};');
      }

      recurrenceRule = parts.join(';');
    }

    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: vm.taskName,
      description: vm.taskDescription,
      color: Colors.blue,
      startDate: !vm.isAllDay
          ? DateTime(
              vm.startDate.year,
              vm.startDate.month,
              vm.startDate.day,
              vm.startTime.hour,
              vm.startTime.minute,
            )
          : vm.startDate,
      endDate: !vm.isAllDay
          ? DateTime(
              vm.endDate.year,
              vm.endDate.month,
              vm.endDate.day,
              vm.endTime.hour,
              vm.endTime.minute,
            )
          : vm.endDate,
      isAllDay: vm.isAllDay,
      recurrenceRule: recurrenceRule,
      duration: vm.durationType,
      priority: 'No Priority',
    );

    await _setTaskUseCase.execute(task);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task saved successfully!')),
    );
    Navigator.pop(context);
  }

  void _editField(
      BuildContext context, ManageTaskViewModel vm, String fieldKey) {
    showDialog(
      context: context,
      builder: (context) {
        return TextInputDialog(
          title: 'Edit ${fieldKey[0].toUpperCase()}${fieldKey.substring(1)}',
          initialValue: fieldKey == 'name' ? vm.taskName : vm.taskDescription,
          onSave: (value) {
            if (fieldKey == 'name') {
              vm.setTaskName(value);
            } else {
              vm.setTaskDescription(value);
            }
          },
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context, ManageTaskViewModel vm, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? vm.startDate : vm.endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      if (isStartDate) {
        vm.setStartDate(picked);
      } else {
        vm.setEndDate(picked);
      }
    }
  }

  Future<void> _selectTime(
      BuildContext context, ManageTaskViewModel vm, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? vm.startTime : vm.endTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (!mounted) return;
    if (picked != null) {
      if (isStartTime) {
        vm.setStartTime(picked);
      } else {
        vm.setEndTime(picked);
      }
    }
  }

  String _formatRepeatDays(String type, List<int> selectedDays) {
    if (selectedDays.isEmpty) return 'Empty';
    selectedDays.sort();

    if (type == 'Weekly') {
      const List<String> shortDays = [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun'
      ];
      return selectedDays
          .where((day) => day >= 1 && day <= 7)
          .map((day) => shortDays[day - 1])
          .join(', ');
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

      return selectedDays
          .where((day) => day >= 1 && day <= 31)
          .map((day) => '$day${suffix(day)}')
          .join(', ');
    } else if (type == 'Yearly') {
      return selectedDays.where((day) => day >= 1 && day <= 365).map((day) {
        final month = DateTime(DateTime.now().year, 1, 1)
            .add(Duration(days: day - 1))
            .month;
        final dayOfMonth = DateTime(DateTime.now().year, 1, 1)
            .add(Duration(days: day - 1))
            .day;
        return '${_getMonthName(month)} - $dayOfMonth';
      }).join(', ');
    }
    return '';
  }

  String _getMonthName(int month) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Future<void> _showDaysPickerDialog(BuildContext context,
      ManageTaskViewModel vm, String type, List<int> selectedDays) async {
    final List<int>? updatedDays = await showDialog<List<int>>(
      context: context,
      builder: (context) =>
          RepeatDaysPickerDialog(type: type, preselectedDays: selectedDays),
    );
    if (updatedDays != null) {
      if (type == 'week') {
        vm.setWeeklyRepeatDays(updatedDays);
      } else if (type == 'month') {
        vm.setMonthlyRepeatDays(updatedDays);
      } else if (type == 'year') {
        vm.setYearlyRepeatDays(updatedDays);
      }
    }
  }

  Future<void> _selectDurationDate(
      BuildContext context, ManageTaskViewModel vm) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: vm.durationDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      vm.setDurationDate(picked);
    }
  }

  Future<void> _selectDurationAmount(
      BuildContext context, ManageTaskViewModel vm) async {
    await showDialog(
      context: context,
      builder: (context) {
        return DurationPickerDialog(
          initialAmount: vm.durationAmount,
          onSave: (amount) {
            vm.setDurationAmount(amount);
          },
        );
      },
    );
  }

  void _editRepeatType(BuildContext context, ManageTaskViewModel vm) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Repeat Type'),
          content: DropdownButton<String>(
            value: vm.repeatType,
            items: vm.repeatOptions.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (value) {
              vm.setRepeatType(value!);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  void _editRepeatInterval(BuildContext context, ManageTaskViewModel vm) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController controller =
            TextEditingController(text: vm.repeatInterval.toString());
        return AlertDialog(
          title: const Text('Set Repeat Interval'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintText: 'Enter interval (e.g., 1, 2, 3)'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                vm.setRepeatInterval(int.tryParse(controller.text) ?? 1);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color disabledColor =
        Theme.of(context).colorScheme.onSurface.withAlpha(
              (Theme.of(context).colorScheme.onSurface.a * 0.38).round(),
            );

    return Consumer<ManageTaskViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Manage Task'),
          ),
          body: ListView(
            children: [
              EditableListTile(
                title: 'Name:',
                subtitle: vm.taskName,
                onTap: () => _editField(context, vm, 'name'),
              ),
              EditableListTile(
                title: 'Description:',
                subtitle: vm.taskDescription,
                onTap: () => _editField(context, vm, 'description'),
              ),
              EditableListTile(
                title: 'Start Date:',
                subtitle: DateFormat.yMMMd().format(vm.startDate),
                onTap: () => _selectDate(context, vm, true),
              ),
              EditableListTile(
                title: 'End Date:',
                subtitle: DateFormat.yMMMd().format(vm.endDate),
                onTap: () => _selectDate(context, vm, false),
              ),
              SwitchListTile(
                title: const Text('All Day'),
                value: vm.isAllDay,
                onChanged: vm.setAllDay,
              ),
              ListTile(
                title: const Text('Start Time:'),
                subtitle: Text(vm.startTime.format(context)),
                onTap:
                    vm.isAllDay ? null : () => _selectTime(context, vm, true),
                enabled: !vm.isAllDay,
                textColor: vm.isAllDay ? disabledColor : null,
              ),
              ListTile(
                title: const Text('End Time:'),
                subtitle: Text(vm.endTime.format(context)),
                onTap:
                    vm.isAllDay ? null : () => _selectTime(context, vm, false),
                enabled: !vm.isAllDay,
                textColor: vm.isAllDay ? disabledColor : null,
              ),
              SwitchListTile(
                title: const Text('Repeat'),
                value: vm.isRepeating,
                onChanged: vm.setRepeating,
              ),
              if (vm.isRepeating)
                ListTile(
                  title: const Text('Repeat Type:'),
                  subtitle: Text(vm.repeatType),
                  onTap: () => _editRepeatType(context, vm),
                ),
              if (vm.isRepeating)
                ListTile(
                  title: const Text('Repeat Interval:'),
                  subtitle: Text('${vm.repeatInterval}'),
                  onTap: () => _editRepeatInterval(context, vm),
                ),
              if (vm.isRepeating && vm.repeatType == 'Weekly')
                ListTile(
                  title: const Text('Select Week Days:'),
                  subtitle: Text(
                    _formatRepeatDays('Weekly', vm.weeklyRepeatDays),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _showDaysPickerDialog(
                      context, vm, 'week', vm.weeklyRepeatDays),
                ),
              if (vm.isRepeating && vm.repeatType == 'Monthly')
                ListTile(
                  title: const Text('Select Month Days:'),
                  subtitle: Text(
                    _formatRepeatDays('Monthly', vm.monthlyRepeatDays),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _showDaysPickerDialog(
                      context, vm, 'month', vm.monthlyRepeatDays),
                ),
              if (vm.isRepeating && vm.repeatType == 'Yearly')
                ListTile(
                  title: const Text('Select Year Days:'),
                  subtitle: Text(
                    _formatRepeatDays('Yearly', vm.yearlyRepeatDays),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _showDaysPickerDialog(
                      context, vm, 'year', vm.yearlyRepeatDays),
                ),
              if (vm.isRepeating)
                ListTile(
                  title: const Text('Duration Type:'),
                  subtitle: Text(vm.durationType),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Select Duration Type'),
                          content: DropdownButton<String>(
                            value: vm.durationType,
                            items: ['Forever', 'Until Date', 'Amount of Times']
                                .map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (value) {
                              vm.setDurationType(value!);
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              if (vm.isRepeating && vm.durationType == 'Until Date')
                ListTile(
                  title: const Text('Duration Date:'),
                  subtitle: Text(
                    vm.durationDate != null
                        ? DateFormat.yMMMd().format(vm.durationDate!)
                        : 'Select a date',
                  ),
                  onTap: () => _selectDurationDate(context, vm),
                ),
              if (vm.isRepeating && vm.durationType == 'Amount of Times')
                ListTile(
                  title: const Text('Duration Amount:'),
                  subtitle: Text(
                    vm.durationAmount != null
                        ? '${vm.durationAmount} times'
                        : 'Set amount',
                  ),
                  onTap: () => _selectDurationAmount(context, vm),
                ),
              const SizedBox(height: 80),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _saveTask(context, vm),
            child: const Icon(Icons.save),
          ),
        );
      },
    );
  }
}
