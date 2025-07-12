import 'package:flutter/material.dart';
import 'package:better_io/features/tasks/presentation/task_management/widgets/dialogs/color_picker_dialog.dart';

class ColorPickerTile extends StatelessWidget {
  final Widget title;
  final Color color;
  final ValueChanged<Color> onColorChanged;
  final Widget? subtitle;

  const ColorPickerTile({
    super.key,
    required this.title,
    required this.color,
    required this.onColorChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle ??
          Text(
            '#${color.a.toInt().toRadixString(16).padLeft(2, '0').toUpperCase()}'
            '${color.r.toInt().toRadixString(16).padLeft(2, '0').toUpperCase()}'
            '${color.g.toInt().toRadixString(16).padLeft(2, '0').toUpperCase()}'
            '${color.b.toInt().toRadixString(16).padLeft(2, '0').toUpperCase()}',
          ),
      trailing: CircleAvatar(backgroundColor: color, radius: 15),
      onTap: () => ColorPickerDialog.show(
        context: context,
        initialColor: color,
        onColorPicked: onColorChanged,
      ),
    );
  }
}
