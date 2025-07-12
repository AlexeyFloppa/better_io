import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorPicked;
  final String title;

  const ColorPickerDialog({
    required this.initialColor,
    required this.onColorPicked,
    this.title = 'Pick a color',
    super.key,
  });

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();

  static Future<void> show({
    required BuildContext context,
    required Color initialColor,
    required ValueChanged<Color> onColorPicked,
    String title = 'Pick a color',
  }) {
    return showDialog(
      context: context,
      builder: (_) => ColorPickerDialog(
        initialColor: initialColor,
        onColorPicked: onColorPicked,
        title: title,
      ),
    );
  }
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color _tempColor;

  @override
  void initState() {
    super.initState();
    _tempColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: _tempColor,
          onColorChanged: (color) => setState(() => _tempColor = color),
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onColorPicked(_tempColor);
            Navigator.of(context).pop();
          },
          child: const Text('Select'),
        ),
      ],
    );
  }
}
