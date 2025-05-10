import 'package:better_io/features/tasks/presentation/components/custom_day_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:better_io/features/tasks/data/repositories/hive_task_repository.dart';
import 'package:hive/hive.dart';
import 'package:better_io/features/tasks/presentation/components/days_picker.dart';
import 'package:better_io/features/tasks/domain/usecases/hive/set_hive_task.dart';
import 'package:better_io/features/tasks/presentation/components/duration_picker_dialog.dart';
import 'package:better_io/features/tasks/presentation/components/editable_list_tile.dart';
import 'package:better_io/features/tasks/presentation/components/text_input_dialog.dart';

class ManageTaskScreen extends StatefulWidget {
  const ManageTaskScreen({Key? key}) : super(key: key);

  @override
  State<ManageTaskScreen> createState() => _ManageTaskScreenState();
}

class _ManageTaskScreenState extends State<ManageTaskScreen> {
  String _taskName = 'Empty';
  String _taskDescription = 'Empty';

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(hours: 1)); // Default to one day later
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);
  bool _isAllDay = false;
  bool _isRepeating = false;
  String _repeatType = 'Daily';
  final List<String> _repeatOptions = ['Hourly', 'Daily', 'Weekly', 'Monthly', 'Yearly', 'Custom'];
  int _repeatInterval = 1;
  List<int> _weeklyRepeatDays = []; // Store selected days for repeat types
  List<int> _monthlyRepeatDays = []; // Store selected days for repeat types
  List<int> _yearlyRepeatDays = []; // Store selected days for repeat types

  Map<String, int> _customRepeatValues = {
    'Years': 0,
    'Months': 0,
    'Weeks': 0,
    'Days': 0,
    'Hours': 0,
    'Minutes': 0,
  };

  String _durationType = 'Forever'; // Default duration type
  DateTime? _durationDate; // For "Until Date"
  int? _durationAmount; // For "Amount of Times"

  late final SetHiveTaskUseCase _setTaskUseCase;

  @override
  void initState() {
    super.initState();
    final taskRepository = HiveTaskRepository(Hive.box('tasks'));
    _setTaskUseCase = SetHiveTaskUseCase(taskRepository);
  }

  Future<void> _saveTask() async {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _taskName, // Use _taskName directly
      description: _taskDescription, // Default to "Empty"
      color: Colors.blue, // Default color
      startDate: _startDate,
      endDate: _endDate,
      isAllDay: _isAllDay,
      isRecurring: _isRepeating,
      recurrenceType: _repeatType,
      recurrenceInterval: _repeatInterval,
      recurrenceDays: _repeatType == 'Weekly'
          ? _weeklyRepeatDays
          : _repeatType == 'Monthly'
              ? _monthlyRepeatDays
              : _yearlyRepeatDays,
      duration: _durationType,
      priority: 'No Priority',
    );
    await _setTaskUseCase.execute(task);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task saved successfully!')),
    );
    Navigator.pop(context);
  }

  void _editField(String fieldKey) {
    showDialog(
      context: context,
      builder: (context) {
        return TextInputDialog(
          title: 'Edit ${fieldKey[0].toUpperCase()}${fieldKey.substring(1)}',
          initialValue: fieldKey == 'name' ? _taskName : _taskDescription,
          onSave: (value) {
            setState(() {
              if (fieldKey == 'name') {
                _taskName = value;
              } else {
                _taskDescription = value;
              }
            });
          },
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  String _formatRepeatDays(String type, List<int> selectedDays) {
    if (selectedDays.isEmpty) return 'Empty';
    selectedDays.sort(); // Sort days in ascending order

    if (type == 'Weekly') {
      const List<String> shortDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return selectedDays
          .where((day) => day >= 1 && day <= 7) // Ensure days are within valid range
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
          .where((day) => day >= 1 && day <= 31) // Ensure days are within valid range
          .map((day) => '$day${suffix(day)}')
          .join(', ');
    } else if (type == 'Yearly') {
      return selectedDays
          .where((day) => day >= 1 && day <= 365) // Ensure days are within valid range
          .map((day) {
            final month = DateTime(DateTime.now().year, 1, 1).add(Duration(days: day - 1)).month;
            final dayOfMonth = DateTime(DateTime.now().year, 1, 1).add(Duration(days: day - 1)).day;
            return '${_getMonthName(month)} - $dayOfMonth';
          })
          .join(', ');
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

  Future<void> _showDaysPickerDialog(String type, List<int> selectedDays) async {
    final List<int>? updatedDays = await showDialog<List<int>>(
      context: context,
      builder: (context) => DaysPickerDialog(type: type, preselectedDays: selectedDays), // Pass preselected days
    );
    if (updatedDays != null) {
      setState(() {
        if (type == 'week') {
          _weeklyRepeatDays = updatedDays;
        } else if (type == 'month') {
          _monthlyRepeatDays = updatedDays;
        } else if (type == 'year') {
          _yearlyRepeatDays = updatedDays;
        }
      });
    }
  }

  Future<void> _showCustomDayPickerDialog() async {
    final Map<String, int>? updatedValues = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) => CustomDayPickerDialog(preselectedValues: _customRepeatValues),
    );
    if (updatedValues != null) {
      setState(() {
        _customRepeatValues = updatedValues;
      });
    }
  }

  Future<void> _selectDurationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _durationDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _durationDate = picked;
      });
    }
  }

  Future<void> _selectDurationAmount(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return DurationPickerDialog(
          initialAmount: _durationAmount,
          onSave: (amount) {
            setState(() {
              _durationAmount = amount;
            });
          },
        );
      },
    );
  }

  void _editRepeatType() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Repeat Type'),
          content: DropdownButton<String>(
            value: _repeatType,
            items: _repeatOptions.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _repeatType = value!;
              });
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  void _editRepeatInterval() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController controller =
            TextEditingController(text: _repeatInterval.toString());
        return AlertDialog(
          title: const Text('Set Repeat Interval'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Enter interval (e.g., 1, 2, 3)'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _repeatInterval = int.tryParse(controller.text) ?? 1;
                });
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
    final Color disabledColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.38);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Task'),
      ),
      body: ListView(
        children: [
          EditableListTile(
            title: 'Name:',
            subtitle: _taskName,
            onTap: () => _editField('name'),
          ),
          EditableListTile(
            title: 'Description:',
            subtitle: _taskDescription,
            onTap: () => _editField('description'),
          ),
          EditableListTile(
            title: 'Start Date:',
            subtitle: DateFormat.yMMMd().format(_startDate),
            onTap: () => _selectDate(context, true),
          ),
          EditableListTile(
            title: 'End Date:',
            subtitle: DateFormat.yMMMd().format(_endDate),
            onTap: () => _selectDate(context, false),
          ),
          SwitchListTile(
            title: const Text('All Day'),
            value: _isAllDay,
            onChanged: (value) {
              setState(() {
                _isAllDay = value;
              });
            },
          ),
          ListTile(
            title: const Text('Start Time:'),
            subtitle: Text(_startTime.format(context)),
            onTap: _isAllDay ? null : () => _selectTime(context, true),
            enabled: !_isAllDay,
            textColor: _isAllDay ? disabledColor : null,
          ),
          ListTile(
            title: const Text('End Time:'),
            subtitle: Text(_endTime.format(context)),
            onTap: _isAllDay ? null : () => _selectTime(context, false),
            enabled: !_isAllDay,
            textColor: _isAllDay ? disabledColor : null,
          ),
          SwitchListTile(
            title: const Text('Repeat'),
            value: _isRepeating,
            onChanged: (value) {
              setState(() {
                _isRepeating = value;
              });
            },
          ),
          if (_isRepeating)
            ListTile(
              title: const Text('Repeat Type:'),
              subtitle: Text(_repeatType),
              onTap: _editRepeatType,
            ),
          if (_isRepeating)
            ListTile(
              title: const Text('Repeat Interval:'),
              subtitle: Text('$_repeatInterval'),
              onTap: _editRepeatInterval,
            ),
          if (_isRepeating && _repeatType == 'Weekly') // Show weekly days picker
            ListTile(
              title: const Text('Select Week Days:'),
              subtitle: Text(
                _formatRepeatDays('Weekly', _weeklyRepeatDays),
                maxLines: 1, // Limit to one line
                overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
              ),
              onTap: () => _showDaysPickerDialog('week', _weeklyRepeatDays), // Pass selected days
            ),
          if (_isRepeating && _repeatType == 'Monthly') // Show monthly days picker
            ListTile(
              title: const Text('Select Month Days:'),
              subtitle: Text(
                _formatRepeatDays('Monthly', _monthlyRepeatDays),
                maxLines: 1, // Limit to one line
                overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
              ),
              onTap: () => _showDaysPickerDialog('month', _monthlyRepeatDays), // Pass selected days
            ),
          if (_isRepeating && _repeatType == 'Yearly') // Show yearly days picker
            ListTile(
              title: const Text('Select Year Days:'),
              subtitle: Text(
                _formatRepeatDays('Yearly', _yearlyRepeatDays),
                maxLines: 1, // Limit to one line
                overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
              ),
              onTap: () => _showDaysPickerDialog('year', _yearlyRepeatDays), // Pass selected days
            ),
          if (_isRepeating && _repeatType == 'Custom') // Show custom day picker
            ListTile(
              title: const Text('Custom Repeat:'),
              subtitle: Text(
                _customRepeatValues.entries
                        .where((entry) => entry.value > 0)
                        .map((entry) => '${entry.value} ${entry.key.toLowerCase()}')
                        .join(', ')
                        .isNotEmpty
                    ? _customRepeatValues.entries
                        .where((entry) => entry.value > 0)
                        .map((entry) => '${entry.value} ${entry.key.toLowerCase()}')
                        .join(', ')
                    : 'Empty', // Default to "Empty" if no values are selected
                maxLines: 1, // Limit to one line
                overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
              ),
              onTap: _showCustomDayPickerDialog,
            ),
          if (_isRepeating) // Show duration-related UI only if repeating is enabled
            ListTile(
              title: const Text('Duration Type:'),
              subtitle: Text(_durationType),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Select Duration Type'),
                      content: DropdownButton<String>(
                        value: _durationType,
                        items: ['Forever', 'Until Date', 'Amount of Times'].map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _durationType = value!;
                            if (_durationType == 'Forever') {
                              _durationDate = null;
                              _durationAmount = null;
                            }
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          if (_isRepeating && _durationType == 'Until Date')
            ListTile(
              title: const Text('Duration Date:'),
              subtitle: Text(
                _durationDate != null ? DateFormat.yMMMd().format(_durationDate!) : 'Select a date',
              ),
              onTap: () => _selectDurationDate(context),
            ),
          if (_isRepeating && _durationType == 'Amount of Times')
            ListTile(
              title: const Text('Duration Amount:'),
              subtitle: Text(
                _durationAmount != null ? '$_durationAmount times' : 'Set amount',
              ),
              onTap: () => _selectDurationAmount(context),
            ),
          const SizedBox(height: 80), // Add spacing to prevent FAB from obscuring UI
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveTask,
        child: const Icon(Icons.save),
      ),
    );
  }
}
