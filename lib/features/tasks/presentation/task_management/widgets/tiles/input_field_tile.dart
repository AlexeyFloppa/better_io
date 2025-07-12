import 'package:flutter/material.dart';
import 'package:better_io/features/tasks/presentation/task_management/widgets/dialogs/input_field_dialog.dart';

class InputFieldTile extends StatelessWidget {
  final Widget title;
  final String value;
  final ValueChanged<String> onChanged;
  final String? dialogTitle;

  const InputFieldTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.dialogTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: Text(value),
      onTap: () => _editTextField(context),
    );
  }

  void _editTextField(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => InputFieldDialog(
        title: dialogTitle ?? 'Edit Value',
        initialValue: value,
        onSave: onChanged,
      ),
    );
  }
}
