import 'package:flutter/material.dart';

class BottomTaskSheet extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onTaskRemove;
  // final VoidCallback onRecurrencyRemove;

  const BottomTaskSheet({
    super.key,
    required this.onEdit,
    required this.onTaskRemove,
    // required this.onRecurrencyRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Remove Task'),
            onTap: () {
              Navigator.pop(context);
              onTaskRemove();
            },
          ),
        ],
      ),
    );
  }
}
