import 'package:flutter/material.dart';

class CustomDayPickerDialog extends StatefulWidget {
  final Map<String, int> preselectedValues; // Preselected values

  const CustomDayPickerDialog({super.key, required this.preselectedValues});

  @override
  CustomDayPickerDialogState createState() => CustomDayPickerDialogState();
}

class CustomDayPickerDialogState extends State<CustomDayPickerDialog> {
  late Map<String, int> _timeValues;

  @override
  void initState() {
    super.initState();
    // Initialize _timeValues with preselected values
    _timeValues = Map.from(widget.preselectedValues);
  }

  void _increment(String key) {
    setState(() {
      _timeValues[key] = _timeValues[key]! + 1;
      _handleCascadingOverflow();
    });
  }

  void _decrement(String key) {
    setState(() {
      if (_timeValues[key]! > 0) {
        _timeValues[key] = _timeValues[key]! - 1;
      }
    });
  }

  void _handleCascadingOverflow() {
    const thresholds = {
      'Minutes': 60,
      'Hours': 24,
      'Days': 7,
      'Weeks': 4,
      'Months': 12,
    };

    final nextKeyOrder = ['Minutes', 'Hours', 'Days', 'Weeks', 'Months', 'Years'];

    for (int i = 0; i < nextKeyOrder.length - 1; i++) {
      final currentKey = nextKeyOrder[i];
      final nextKey = nextKeyOrder[i + 1];

      if (thresholds.containsKey(currentKey) && _timeValues[currentKey]! >= thresholds[currentKey]!) {
        final overflow = _timeValues[currentKey]! ~/ thresholds[currentKey]!;
        _timeValues[currentKey] = _timeValues[currentKey]! % thresholds[currentKey]!;
        _timeValues[nextKey] = (_timeValues[nextKey] ?? 0) + overflow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Time Values',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _timeValues.keys.map((key) {
                  return _TimePickerContainer(
                    label: key,
                    value: _timeValues[key]!,
                    onIncrement: () => _increment(key),
                    onDecrement: () => _decrement(key),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(_timeValues);
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimePickerContainer extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _TimePickerContainer({
    required this.label,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 80, // Fixed width for each container
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.arrow_drop_up),
            color: theme.colorScheme.primary,
          ),
          Text(
            '$value',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          IconButton(
            onPressed: onDecrement,
            icon: const Icon(Icons.arrow_drop_down),
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}