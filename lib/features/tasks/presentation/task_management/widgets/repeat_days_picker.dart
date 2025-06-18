import 'package:flutter/material.dart';

class RepeatDaysPickerDialog extends StatefulWidget {
  final String type; // 'week', 'month', or 'year'
  final List<int> preselectedDays;

  const RepeatDaysPickerDialog({
    super.key,
    required this.type,
    required this.preselectedDays,
  });

  @override
  State<RepeatDaysPickerDialog> createState() => _RepeatDaysPickerDialogState();
}

class _RepeatDaysPickerDialogState extends State<RepeatDaysPickerDialog> {
  static const List<String> _months = [
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

  final Map<int, Set<int>> _selectedDaysByMonth = {};
  int _currentMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    _initializeSelectedDays();
  }

  void _initializeSelectedDays() {
    if (widget.type == 'year') {
      for (final dayOfYear in widget.preselectedDays) {
        final date = DateTime(DateTime.now().year, 1, 1)
            .add(Duration(days: dayOfYear - 1));
        _selectedDaysByMonth
            .putIfAbsent(date.month, () => <int>{})
            .add(date.day);
      }
    } else if (widget.type == 'month') {
      _selectedDaysByMonth[_currentMonth] = widget.preselectedDays.toSet();
    } else if (widget.type == 'week') {
      _selectedDaysByMonth[1] = widget.preselectedDays.toSet();
    }
  }

  int get _itemCount {
    switch (widget.type) {
      case 'year':
        return DateTime(DateTime.now().year, _currentMonth + 1, 0).day;
      case 'month':
        return 31;
      case 'week':
        return 7;
      default:
        return 0;
    }
  }

  Set<int> get _selectedDays {
    if (widget.type == 'week') {
      return _selectedDaysByMonth[1] ?? {};
    }
    return _selectedDaysByMonth[_currentMonth] ?? {};
  }

  void _changeMonth(int direction) {
    setState(() {
      _currentMonth = (_currentMonth + direction - 1) % 12 + 1;
    });
  }

  double _calculateChipWidth(BuildContext context) {
    const double maxChipWidth = 60.0;
    final double availableWidth = MediaQuery.of(context).size.width * 0.85;
    final double chipWidth = (availableWidth / 7) - 8.0;
    return chipWidth > maxChipWidth ? maxChipWidth : chipWidth;
  }

  List<Widget> _buildDayRows(double chipWidth) {
    final List<Widget> rows = [];
    final int totalRows = (_itemCount / 7).ceil();

    for (int row = 0; row < totalRows; row++) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(7, (col) {
              final int day = row * 7 + col + 1;
              if (day > _itemCount) return const SizedBox.shrink();
              final bool isSelected = _selectedDays.contains(day);
              return SizedBox(
                width: chipWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    padding: EdgeInsets.symmetric(
                      horizontal: chipWidth < 60.0 ? 0.0 : 4.0,
                    ),
                    label: Center(child: Text('$day')),
                    selected: isSelected,
                    onSelected: (_) => _toggleDay(day, isSelected),
                  ),
                ),
              );
            }),
          ),
        ),
      );
    }
    return rows;
  }

  void _toggleDay(int day, bool isSelected) {
    setState(() {
      final int key = widget.type == 'week' ? 1 : _currentMonth;
      final days = _selectedDaysByMonth.putIfAbsent(key, () => <int>{});
      isSelected ? days.remove(day) : days.add(day);
    });
  }

  List<int> _collectSelectedDays() {
    if (widget.type == 'year') {
      return _selectedDaysByMonth.entries.expand((entry) {
        final int month = entry.key;
        final days = entry.value;
        return days.map((day) {
          final date = DateTime(DateTime.now().year, month, day);
          return date.difference(DateTime(date.year, 1, 0)).inDays + 1;
        });
      }).toList();
    } else {
      return _selectedDays.toList();
    }
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _changeMonth(-1),
        ),
        Text(
          _months[_currentMonth - 1],
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => _changeMonth(1),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double chipWidth = _calculateChipWidth(context);
    final double dialogWidth = (chipWidth + 8.0) * 7;

    return AlertDialog(
      title: Text('Select day in ${widget.type}'),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.type == 'year') _buildMonthSelector(),
            ..._buildDayRows(chipWidth),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _collectSelectedDays()),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
