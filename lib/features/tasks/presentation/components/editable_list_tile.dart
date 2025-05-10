import 'package:flutter/material.dart';

class EditableListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const EditableListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle.isNotEmpty ? subtitle : 'Empty'),
      onTap: onTap,
    );
  }
}
