import 'package:flutter/material.dart';

import 'package:better_io/features/tasks/presentation/task_management/widgets/dialogs/option_picker_dialog.dart';

class OptionPickerTile<T extends Enum> extends StatelessWidget {
  final Widget title;
  final T selectedValue;
  final List<T> options;
  final ValueChanged<T> onSelect;
  final String dialogTitle;
  final Widget? subtitle;
  final String Function(T) getLabel;

  const OptionPickerTile({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.options,
    required this.onSelect,
    required this.dialogTitle,
    required this.getLabel,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle ?? Text(getLabel(selectedValue)),
      onTap: () => OptionPickerDialog.show(
        context,
        title: dialogTitle,
        options: options.map(getLabel).toList(),
        selected: getLabel(selectedValue),
        onSelect: (selectedLabel) {
          final selectedEnum =
              options.firstWhere((option) => getLabel(option) == selectedLabel);
          onSelect(selectedEnum);
        },
      ),
    );
  }
}
