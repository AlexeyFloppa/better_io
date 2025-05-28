import 'package:flutter/material.dart';

class RepeatDaysPickerDialog extends StatefulWidget {
  final String type; // 'week', 'month', 'year'
  final List<int> preselectedDays; // Preselected days

  const RepeatDaysPickerDialog(
      {super.key, required this.type, required this.preselectedDays});

  @override
  State<RepeatDaysPickerDialog> createState() => _RepeatDaysPickerDialogState();
}

class _RepeatDaysPickerDialogState extends State<RepeatDaysPickerDialog> {
  final Map<int, Set<int>> selectedDaysByMonth =
      {}; // Store selected days for each month
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
    // Initialize selected days based on preselectedDays
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
          widget.preselectedDays.toSet(); // Use key 1 for weekly days
    }
  }

  int get itemCount {
    if (widget.type == 'year') {
      return DateTime(DateTime.now().year, currentMonth + 1, 0)
          .day; // Days in the current month
    }
    switch (widget.type) {
      case 'week':
        return 7; // 7 days in a week
      case 'month':
        return 31; // Maximum days in a month
      default:
        return 0;
    }
  }

  Set<int> get selectedDays {
    if (widget.type == 'week') {
      return selectedDaysByMonth[1] ?? {}; // Use key 1 for weekly days
    }
    return selectedDaysByMonth[currentMonth] ?? {};
  }

  void _changeMonth(int direction) {
    setState(() {
      currentMonth =
          (currentMonth + direction - 1) % 12 + 1; // Cycle through months
    });
  }

  @override
  Widget build(BuildContext context) {
    final double chipWidth = 60.0; // Fixed width for each chip
    final double paddingWidth = 8.0; // Padding between chips
    final double dialogWidth =
        (chipWidth + paddingWidth) * 7; // Calculate width for 7 chips per row

    final rows = <Widget>[];
    for (int i = 0; i < (itemCount / 7).ceil(); i++) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8), // Add spacing between rows
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              7,
              (j) {
                final day = i * 7 + j + 1;
                if (day > itemCount) return const SizedBox.shrink();
                final isSelected = selectedDays.contains(day);
                return SizedBox(
                  width: chipWidth, // Fixed width for the chip container
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0), // Add spacing between chips
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
          maxWidth: dialogWidth, // Dynamically set max width
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.type == 'year') // Show month swiper only for yearly type
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
            // Flatten selected days into a list
            final List<int> allSelectedDays = widget.type == 'year'
                ? selectedDaysByMonth.entries.expand((entry) {
                    final month = entry.key;
                    final days = entry.value;
                    return days.map((day) {
                      final date = DateTime(DateTime.now().year, month, day);
                      return date.difference(DateTime(date.year, 1, 1)).inDays +
                          1; // Day of the year
                    });
                  }).toList()
                : selectedDays
                    .toList(); // For week and month, return selected days directly
            Navigator.pop(context, allSelectedDays); // Return the selected days
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
