import 'package:flutter/material.dart';

class RepeatDaysPickerDialog extends StatefulWidget {
  final String type;
  final List<int> preselectedDays;

  const RepeatDaysPickerDialog(
      {super.key, required this.type, required this.preselectedDays});

  @override
  State<RepeatDaysPickerDialog> createState() => _RepeatDaysPickerDialogState();
}

class _RepeatDaysPickerDialogState extends State<RepeatDaysPickerDialog> {
  final Map<int, Set<int>> selectedDaysByMonth ={};
  int currentMonth = DateTime.now().month;

  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.type == 'year') {
      for (final dayOfYear in widget.preselectedDays) {
        final date = DateTime(DateTime.now().year, 1, 1)
            .add(Duration(days: dayOfYear - 1));
        selectedDaysByMonth.putIfAbsent(date.month, () => {}).add(date.day);
      }
    } else if (widget.type == 'month') {
      selectedDaysByMonth[currentMonth] = widget.preselectedDays.toSet();
    } else if (widget.type == 'week') {
      selectedDaysByMonth[1] =
          widget.preselectedDays.toSet();
    }
  }

  int get itemCount {
    if (widget.type == 'year') {
      return DateTime(DateTime.now().year, currentMonth + 1, 0)
          .day;
    }
    switch (widget.type) {
      case 'week':
        return 7;
      case 'month':
        return 31;
      default:
        return 0;
    }
  }

  Set<int> get selectedDays {
    if (widget.type == 'week') {
      return selectedDaysByMonth[1] ?? {};
    }
    return selectedDaysByMonth[currentMonth] ?? {};
  }

  void _changeMonth(int direction) {
    setState(() {
      currentMonth =
          (currentMonth + direction - 1) % 12 + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double chipWidth = 60.0;
    final double paddingWidth = 8.0;
    final double dialogWidth =
        (chipWidth + paddingWidth) * 7;

    final rows = <Widget>[];
    for (int i = 0; i < (itemCount / 7).ceil(); i++) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              7,
              (j) {
                final day = i * 7 + j + 1;
                if (day > itemCount) return const SizedBox.shrink();
                final isSelected = selectedDays.contains(day);
                return SizedBox(
                  width: chipWidth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0),
                    child: FilterChip(
                      label: Center(child: Text('$day')),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          final days = selectedDaysByMonth.putIfAbsent(
                              widget.type == 'week' ? 1 : currentMonth,
                              () => <int>{});
                          if (isSelected) {
                            days.remove(day);
                          } else {
                            days.add(day);
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    return AlertDialog(
      title: Text('Select day in ${widget.type}'),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.type == 'year')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => _changeMonth(-1),
                  ),
                  Text(
                    months[currentMonth - 1],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () => _changeMonth(1),
                  ),
                ],
              ),
            ...rows,
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final List<int> allSelectedDays = widget.type == 'year'
                ? selectedDaysByMonth.entries.expand((entry) {
                    final month = entry.key;
                    final days = entry.value;
                    return days.map((day) {
                      final date = DateTime(DateTime.now().year, month, day);
                      return date.difference(DateTime(date.year, 1, 0)).inDays +
                          1;
                    });
                  }).toList()
                : selectedDays
                    .toList();
            Navigator.pop(context, allSelectedDays);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
