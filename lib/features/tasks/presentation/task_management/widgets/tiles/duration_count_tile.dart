import 'package:flutter/material.dart';
import 'package:better_io/features/tasks/presentation/task_management/widgets/dialogs/duration_picker_dialog.dart';

class DurationCountTile extends StatelessWidget {
  final Widget title;
  final int? durationCount;
  final Function(int?) onChanged;

  const DurationCountTile({
    super.key,
    required this.title,
    required this.durationCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: Text(durationCount?.toString() ?? 'Set Count'),
      onTap: () => _showDurationCountDialog(context),
    );
  }

  void _showDurationCountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => DurationPickerDialog(
        initialCount: durationCount,
        onSave: onChanged,
      ),
    );
  }
}
